package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/signal"
	"slices"
	"time"

	_ "github.com/lib/pq"
	kafka "github.com/segmentio/kafka-go"
)

type User struct {
	UserID   int
	Username string
	Email    string
	Password string
}

type Artist struct {
	ID     int
	Name   string
	Albums []Album
}

type Album struct {
	ID       int
	Title    string
	ArtistID int
	Songs    []Song
}

type Song struct {
	ID       int
	Title    string
	Duration int
	AlbumID  int
}

type Event struct {
	UserID    int    `json:"user_id"`
	ArtistID  int    `json:"artist_id"`
	AlbumID   int    `json:"album_id"`
	SongID    int    `json:"song_id"`
	EventType string `json:"event_type"`
}

var (
	users        []User
	artists      []Artist
	dbEventTypes = []string{
		"song_liked",
		"song_disliked",
		"artist_followed",
		"artist_unfollowed",
	}
	kafkaEventTypes = []string{
		"song_started_playing",
		"song_paused",
		"song_skipped",
	}
	eventTypes = append(dbEventTypes, kafkaEventTypes...)
)

func main() {
	kafkaUrl := "kafka-service.kafka.svc.cluster.local:9092"
	log.Printf("Connecting to kafka at %s", kafkaUrl)
	kafkaConn, err := kafka.DialLeader(context.Background(), "tcp", kafkaUrl, "song-events", 0)
	if err != nil {
		log.Fatal(err)
	}
	defer kafkaConn.Close()

	dbConnStr := "host=postgres-service port=5432 user=crabifyschrabify password=password dbname=crabify sslmode=disable"
	db, err := sql.Open("postgres", dbConnStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	loadData(db) // load data from pg

	// listen for sigint
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	// limit to 10 concurrent goroutines
	semaphore := make(chan bool, 10)

EventGenerator:
	for {
		select {
		case <-c:
			fmt.Println("received ctrl+c")
			break EventGenerator
		default:
			semaphore <- true
			go generateAndPublishEvent(semaphore, db, kafkaConn)
		}
	}
}

func generateAndPublishEvent(semaphore <-chan bool, db *sql.DB, kafkaConn *kafka.Conn) {
	defer func() {
		time.Sleep(1 * time.Second)
		<-semaphore
	}()

	event := generateUserEvent()

	var publishErr error
	if slices.Contains(dbEventTypes, event.EventType) {
		publishErr = publishDbEvent(db, event)
	} else if slices.Contains(kafkaEventTypes, event.EventType) {
		publishErr = publishKafkaEvent(kafkaConn, event)
	} else {
		log.Printf("[ERR] Invalid event type: %s", event.EventType)
	}

	if publishErr != nil {
		log.Printf("[ERR] %s", publishErr)
	}
}

func loadData(db *sql.DB) {
	// Load user data
	rows, err := db.Query("SELECT user_id, username, email, password FROM users")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var user User
		err := rows.Scan(&user.UserID, &user.Username, &user.Email, &user.Password)
		if err != nil {
			log.Fatal(err)
		}
		users = append(users, user)
	}

	// Load artist data
	rows, err = db.Query("SELECT artist_id, artist_name FROM artists")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var artist Artist
		err := rows.Scan(&artist.ID, &artist.Name)
		if err != nil {
			log.Fatal(err)
		}
		artists = append(artists, artist)
	}

	// Load album data
	rows, err = db.Query("SELECT album_id, album_title, artist_id FROM albums")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var album Album
		err := rows.Scan(&album.ID, &album.Title, &album.ArtistID)
		if err != nil {
			log.Fatal(err)
		}
		for i, artist := range artists {
			if artist.ID == album.ArtistID {
				artists[i].Albums = append(artists[i].Albums, album)
			}
		}
	}

	// Load song data
	rows, err = db.Query("SELECT song_id, song_title, duration, album_id FROM songs")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var song Song
		err := rows.Scan(&song.ID, &song.Title, &song.Duration, &song.AlbumID)
		if err != nil {
			log.Fatal(err)
		}
		for i, artist := range artists {
			for j, album := range artist.Albums {
				if album.ID == song.AlbumID {
					artists[i].Albums[j].Songs = append(artists[i].Albums[j].Songs, song)
				}
			}
		}
	}
}

func generateUserEvent() Event {
	rUser := users[rand.Intn(len(users))]
	rArtist := artists[rand.Intn(len(artists))]
	rAlbum := rArtist.Albums[rand.Intn(len(rArtist.Albums))]
	rSong := rAlbum.Songs[rand.Intn(len(rAlbum.Songs))]
	rEventType := eventTypes[rand.Intn(len(eventTypes))]

	// generate event
	fmt.Printf(
		"User: %s\nEvent: %s\nArtist: %s\nAlbum: %s\nSong: %s\n\n",
		rUser.Username, rEventType, rArtist.Name, rAlbum.Title, rSong.Title,
	)

	return Event{
		UserID:    rUser.UserID,
		ArtistID:  rArtist.ID,
		AlbumID:   rAlbum.ID,
		SongID:    rSong.ID,
		EventType: rEventType,
	}
}

func publishDbEvent(db *sql.DB, event Event) error {
	var q string
	var err error

	switch event.EventType {
	case "song_liked":
		q = "INSERT INTO liked_songs (user_id, song_id, like_timestamp) VALUES ($1, $2, $3)"
		_, err = db.Exec(
			q,
			event.UserID, event.SongID, time.Now(),
		)

	case "song_disliked": // TODO: don't forget to handle this when streaming
		q = "INSERT INTO disliked_songs (user_id, song_id, dislike_timestamp) VALUES ($1, $2, $3)"
		_, err = db.Exec(
			q,
			event.UserID, event.SongID, time.Now(),
		)

	case "artist_followed":
		q = "INSERT INTO artists_followed (user_id, artist_id, follow_timestamp) VALUES ($1, $2, $3)"
		_, err = db.Exec(
			q,
			event.UserID, event.ArtistID, time.Now(),
		)

	case "artist_unfollowed":
		q = "DELETE FROM artists_followed WHERE user_id = $1 AND artist_id = $2"
		_, err = db.Exec(
			q,
			event.UserID, event.ArtistID,
		)

	default:
		err = fmt.Errorf("Invalid event type: %s", event.EventType)
	}

	return err
}

func publishKafkaEvent(kafkaConn *kafka.Conn, event Event) error {
	// jsonify the event
	jsonEvent, err := json.Marshal(event)
	if err != nil {
		return err
	}

	log.Printf("Publishing event: %s", jsonEvent)
	_, err = kafkaConn.WriteMessages(kafka.Message{Value: []byte(jsonEvent)})

	return err
}

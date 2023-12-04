package main

import (
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

type User struct {
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

var (
	users   []User
	artists []Artist
)

func main() {
	// Load data into memory
	loadData()

	for _, user := range users {
		log.Println(user.Username)
	}

	for _, artist := range artists {
		log.Println(artist.Name)
		for _, album := range artist.Albums {
			log.Println(album.Title)
			for _, song := range album.Songs {
				log.Println(song.Title)
			}
		}
	}
}

func loadData() {
	connStr := "host=postgres-service port=5432 user=crabifyschrabify password=password dbname=crabify sslmode=disable"
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Load user data
	rows, err := db.Query("SELECT username, email, password FROM users")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		var user User
		err := rows.Scan(&user.Username, &user.Email, &user.Password)
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

func generateUserEvents() {
}

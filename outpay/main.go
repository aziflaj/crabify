package main

import (
	"log"

	"github.com/gocql/gocql"
)

func main() {
	cluster := gocql.NewCluster("cassandra")
	cluster.Keyspace = "crabify_analytics"
	session, err := cluster.CreateSession()

	if err != nil {
		log.Fatal(err)
	}

	cql := `
		SELECT artist_id, artist_name, SUM(duration) AS total_playtime
		FROM playtime
		GROUP BY artist_id
	`
	iter := session.Query(cql).Iter()

	// result set keys
	var artist_id int
	var artist_name string
	var total_playtime int

	for {
		row := map[string]interface{}{
			"artist_id":      &artist_id,
			"artist_name":    &artist_name,
			"total_playtime": &total_playtime,
		}

		if !iter.MapScan(row) {
			log.Println("Done Processing")
			break
		}

		log.Printf("Pay %s (id: %d) for %d seconds of Play time", artist_name, artist_id, total_playtime)
	}
}

# Description: Handles song events from Kafka and pushes to Cassandra
# Sample message {"user_id":2,"artist_id":1,"album_id":1,"song_id":10,"event_type":"song_paused"}
def song_events_handler(message):
    print(f"Received message {message})")
    song_query = """
    SELECT song_title, artist_name, album_title
    FROM songs
    JOIN albums ON songs.album_id = albums.album_id
    JOIN artists ON albums.artist_id = artists.artist_id
    WHERE song_id = ?
    """

    user_query = """
    SELECT username, subscription_status
    FROM users
    WHERE user_id = ?
    """

    # TODO: get results for the above query

    # insert into cassandra
    cql = """
    INSERT INTO song_events (username, song_id, song_title, artist_id, artist_name, album_id, album_title, event_type)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """

    # TODO: store these in Cassandra

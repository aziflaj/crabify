import uuid
import psycopg2.extras

# Description: Handles song events from Kafka and pushes to Cassandra
# Sample message {"user_id":2,"artist_id":1,"album_id":1,"song_id":10,"event_type":"song_paused"}
def song_events_handler(source, sink, message):
    song_query = """
    SELECT song_title, artist_name, album_title
    FROM songs
    JOIN albums ON songs.album_id = albums.album_id
    JOIN artists ON albums.artist_id = artists.artist_id
    WHERE song_id = %s
    """
    user_query = """
    SELECT username, subscription_status
    FROM users
    WHERE user_id = %s
    """

    # insert into cassandra
    cql = sink.prepare("""
    INSERT INTO song_events (
        event_id,
        user_id,
        username,
        song_id,
        song_title,
        artist_id,
        artist_name,
        album_id,
        album_title,
        event_type
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """)

    with source.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cursor:
        cursor.execute(song_query, (message["song_id"],))
        song_data = cursor.fetchone()

        cursor.execute(user_query, (message["user_id"],))
        user_data = cursor.fetchone()

        sink.execute(cql, [
            uuid.uuid4(),
            message["user_id"],
            user_data["username"],
            message["song_id"],
            song_data["song_title"],
            message["artist_id"],
            song_data["artist_name"],
            message["album_id"],
            song_data["album_title"],
            message["event_type"]
        ])

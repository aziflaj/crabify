from utils import store_event

# Description: Handles song events from Kafka and pushes to Cassandra
# Sample message {"user_id":2,"artist_id":1,"album_id":1,"song_id":10,"event_type":"song_paused"}
def song_events_handler(source, sink, message):
    data = {
        'user_id': message["user_id"],
        'song_id': message["song_id"],
        'event_type': message["event_type"],
        'duration': message["duration"] if "duration" in message else 0
    }

    enriched_data = store_event(source, sink, data)

    if message["event_type"] == "song_skipped" or message["event_type"] == "song_finished_playing":
        cql = sink.prepare("""
        INSERT INTO playtime (
            username,
            song_id, song_title, artist_id, artist_name,
            duration
        ) VALUES (
            ?,
            ?, ?, ?, ?,
            ?
        )
        """)

        sink.execute(cql, [
            enriched_data["username"],
            enriched_data["song_id"],
            enriched_data["song_title"],
            enriched_data["artist_id"],
            enriched_data["artist_name"],
            enriched_data["duration"]
        ])

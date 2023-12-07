from psycopg2.extras import RealDictCursor

# song_id:
# user_id:
# event_type:
def store_event(source, sink, data):
    song_query = """
    SELECT song_title, artists.artist_id as artist_id, artist_name, albums.album_id as album_id, album_title
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
        event_type,
        user_id, username,
        song_id, song_title,
        artist_id, artist_name,
        album_id, album_title,
        duration,
        created_at
    ) VALUES (
        ?,
        ?, ?,
        ?, ?,
        ?, ?,
        ?, ?,
        ?,
        toTimestamp(now())
    )
    """)

    with source.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute(song_query, (data["song_id"],))
        song_data = cursor.fetchone()

        cursor.execute(user_query, (data["user_id"],))
        user_data = cursor.fetchone()

        sink.execute(cql, [
            data["event_type"],
            data["user_id"], user_data["username"],
            data["song_id"], song_data["song_title"],
            song_data["artist_id"], song_data["artist_name"],
            song_data["album_id"], song_data["album_title"],
            data["duration"]
        ])

    return {
        'event_type': data["event_type"],
        'user_id': data["user_id"],
        'username': user_data["username"],
        'song_id': data["song_id"],
        'song_title': song_data["song_title"],
        'artist_id': song_data["artist_id"],
        'artist_name': song_data["artist_name"],
        'album_id': song_data["album_id"],
        'album_title': song_data["album_title"],
        'duration': data["duration"]
    }

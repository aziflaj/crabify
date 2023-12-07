from psycopg2.extras import RealDictCursor

def disliked_songs_handler(source, sink, message):
    print(f"Handling disliked song: {message}")
    # TODO: 1. remove liked song from Pg if liked before disliked timestamp
    previously_liked_song_query = """
    SELECT id
    FROM liked_songs
    WHERE song_id = %s AND like_timestamp < NOW()
    """
    delete_liked_song_query = """
    DELETE FROM liked_songs
    WHERE song_id IN %s
    """
    song_query = """
    SELECT song_title, artist_name, album_title
    FROM songs
    JOIN albums ON songs.album_id = albums.album_id
    JOIN artists ON albums.artist_id = artists.artist_id
    WHERE song_id = %s
    """

    with source.cursor(cursor_factory=RealDictCursyr) as cursor:
        cursor.execute(previously_liked_song_query, (message["song_id"], message["disliked_timestamp"]))
        rows = cursor.fetchall()

        if len(rows) > 0:
            cursor.execute(delete_liked_song_query, (tuple(rows),))
            source_conn.commit()

        cursor.execute(song_query, (message["song_id"],))
        song = cursor.fetchone()

    # TODO: 2. insert disliked song into Cassandra
    print(message)

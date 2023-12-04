-- Table: users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_date TIMESTAMP,
    subscription_status BOOLEAN DEFAULT FALSE,
    other_user_profile_data JSONB
);

-- Table: artists
CREATE TABLE artists (
    artist_id SERIAL PRIMARY KEY,
    artist_name VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    other_artist_data JSONB
);

-- Table: albums
CREATE TABLE albums (
    album_id SERIAL PRIMARY KEY,
    album_title VARCHAR(255) NOT NULL,
    release_date DATE,
    artist_id INT REFERENCES artists(artist_id),
    other_album_data JSONB
);

-- Table: songs
CREATE TABLE songs (
    song_id SERIAL PRIMARY KEY,
    song_title VARCHAR(255) NOT NULL,
    duration INT,
    album_id INT REFERENCES albums(album_id),
    other_song_data JSONB
);

-- Table: liked_songs
CREATE TABLE liked_songs (
    like_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    song_id INT REFERENCES songs(song_id),
    like_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: disliked_songs
CREATE TABLE disliked_songs (
    dislike_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    song_id INT REFERENCES songs(song_id),
    dislike_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: artists_followed
CREATE TABLE artists_followed (
    follow_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    artist_id INT REFERENCES artists(artist_id),
    follow_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: liked_albums
CREATE TABLE liked_albums (
    like_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    album_id INT REFERENCES albums(album_id),
    like_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: disliked_albums
CREATE TABLE disliked_albums (
    dislike_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    album_id INT REFERENCES albums(album_id),
    dislike_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: playlists
CREATE TABLE playlists (
    playlist_id SERIAL PRIMARY KEY,
    playlist_name VARCHAR(255) NOT NULL,
    user_id INT REFERENCES users(user_id),
    other_playlist_data JSONB
);

-- Table: playlist_songs
CREATE TABLE playlist_songs (
    id SERIAL PRIMARY KEY,
    playlist_id INT REFERENCES playlists(playlist_id),
    song_id INT REFERENCES songs(song_id)
);


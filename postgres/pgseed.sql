-- User profiles with plaintext password
INSERT INTO users (username, email, password, registration_date) VALUES
    ('musiclover1', 'musiclover1@example.com', 'password', '2023-01-01'),
    ('hiphopfanatic', 'hiphopfanatic@example.com', 'password', '2023-01-02'),
    ('technojunkie', 'technojunkie@example.com', 'password', '2023-01-03'),
    ('rocknroller', 'rocknroller@example.com', 'password', '2023-01-04'),
    ('jazzcat', 'jazzcat@example.com', 'password', '2023-01-05');


INSERT INTO artists (artist_name, genre, other_artist_data) VALUES
    ('Pink Floyd', 'Rock', '{"description": "Legendary rock band"}'),
    ('Frank Zappa', 'Experimental', '{"description": "Innovative musician and composer"}'),
    ('Infected Mushroom', 'Electronic', '{"description": "Psytrance duo"}'),
    ('The Prodigy', 'Electronic', '{"description": "Electronic music pioneers"}'),
    ('Led Zeppelin', 'Rock', '{"description": "Iconic rock band"}'),
    ('Biggie Smalls', 'Hip Hop', '{"description": "Legendary rapper"}'),
    ('Wu-Tang Clan', 'Hip Hop', '{"description": "Hip hop collective"}');

-- Pink Floyd
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('The Dark Side of the Moon', '1973-03-01', 1, '{"description": "Classic album"}'),
    ('Wish You Were Here', '1975-09-12', 1, '{"description": "Another classic album"}'),
    ('Animals', '1977-01-23', 1, '{"description": "Progressive rock masterpiece"}');

-- Songs for Pink Floyd's "The Dark Side of the Moon"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Speak to Me', 90, 1, '{"description": "Intro"}'),
    ('Breathe', 163, 1, '{"description": "First song"}'),
    ('On the Run', 212, 1, '{"description": "Instrumental track"}'),
    ('Time', 413, 1, '{"description": "Conceptual song about time"}'),
    ('The Great Gig in the Sky', 276, 1, '{"description": "Vocal solo"}'),
    ('Money', 383, 1, '{"description": "Hit single with distinctive cash register sounds"}'),
    ('Us and Them', 462, 1, '{"description": "Jazz-influenced track"}'),
    ('Any Colour You Like', 205, 1, '{"description": "Instrumental"}'),
    ('Brain Damage', 228, 1, '{"description": "Conceptual song"}'),
    ('Eclipse', 122, 1, '{"description": "Closing track"}');

-- Songs for Pink Floyd's "Wish You Were Here"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Shine On You Crazy Diamond (Parts I-V)', 810, 2, '{"description": "Epic suite"}'),
    ('Welcome to the Machine', 447, 2, '{"description": "Conceptual song"}'),
    ('Have a Cigar', 317, 2, '{"description": "Featuring guest vocals"}'),
    ('Wish You Were Here', 335, 2, '{"description": "Title track"}'),
    ('Shine On You Crazy Diamond (Parts VI-IX)', 839, 2, '{"description": "Continuation of suite"}');

-- Songs for Pink Floyd's "Animals"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Pigs on the Wing (Part 1)', 92, 3, '{"description": "Opening track"}'),
    ('Dogs', 735, 3, '{"description": "Progressive rock epic"}'),
    ('Pigs (Three Different Ones)', 727, 3, '{"description": "Political commentary"}'),
    ('Sheep', 772, 3, '{"description": "Featuring synthesized vocals"}'),
    ('Pigs on the Wing (Part 2)', 103, 3, '{"description": "Closing track"}');


-- Frank Zappa
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('Hot Rats', '1969-10-10', 2, '{"description": "Jazz-rock fusion masterpiece"}'),
    ('Apostrophe ('')', '1974-03-22', 2, '{"description": "Zappa''s highest-charting album"}'),
    ('Joe''s Garage Act I', '1979-09-03', 2, '{"description": "Conceptual rock opera"}');

-- Songs for Frank Zappa's "Hot Rats"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Peaches en Regalia', 177, 4, '{"description": "Instrumental masterpiece"}'),
    ('Willie the Pimp', 504, 4, '{"description": "Featuring Captain Beefheart"}'),
    ('Son of Mr. Green Genes', 118, 4, '{"description": "Instrumental"}'),
    ('Little Umbrellas', 126, 4, '{"description": "Instrumental"}'),
    ('The Gumbo Variations', 621, 4, '{"description": "Extended instrumental jam"}');

-- Songs for Frank Zappa's "Apostrophe (')"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Don''t Eat the Yellow Snow', 174, 5, '{"description": "Part I"}'),
    ('Nanook Rubs It', 276, 5, '{"description": "Part II"}'),
    ('St. Alfonzo''s Pancake Breakfast', 156, 5, '{"description": "Part III"}'),
    ('Father O''Blivion', 138, 5, '{"description": "Part IV"}'),
    ('Cosmik Debris', 253, 5, '{"description": "Featuring backup vocals by Tina Turner"}');

-- Songs for Frank Zappa's "Joe's Garage Act I"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Joe''s Garage', 358, 6, '{"description": "Title track"}'),
    ('Catholic Girls', 332, 6, '{"description": "Part I"}'),
    ('Crew Slut', 219, 6, '{"description": "Part II"}'),
    ('Fembot in a Wet T-Shirt', 343, 6, '{"description": "Part III"}'),
    ('On the Bus', 321, 6, '{"description": "Part IV"}');

INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('The Gathering', '1999-07-01', 3, '{"description": "Debut album"}'),
    ('Converting Vegetarians', '2003-10-26', 3, '{"description": "Double album"}'),
    ('Vicious Delicious', '2007-03-26', 3, '{"description": "Critical and commercial success"}');

-- Songs for Infected Mushroom's "The Gathering"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Release Me', 418, 7, '{"description": "Psytrance anthem"}'),
    ('The Gathering', 437, 7, '{"description": "Title track"}'),
    ('Return of the Shadows', 466, 7, '{"description": "Energetic track"}'),
    ('Blue Muppet', 346, 7, '{"description": "Instrumental"}'),
    ('Psycho', 367, 7, '{"description": "Featuring DJ Jörg"}');

-- Songs for Infected Mushroom's "Converting Vegetarians"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Converting Vegetarians', 453, 8, '{"description": "Title track"}'),
    ('Elation Station', 468, 8, '{"description": "Uplifting trance"}'),
    ('Drop Out', 364, 8, '{"description": "Featuring The Doors"}'),
    ('Avratz', 427, 8, '{"description": "Instrumental"}'),
    ('Blink', 317, 8, '{"description": "Featuring Perry Farrell"}');

-- Songs for Infected Mushroom's "Vicious Delicious"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Becoming Insane', 368, 9, '{"description": "Hit single"}'),
    ('Artillery', 437, 9, '{"description": "Epic psytrance"}'),
    ('Vicious Delicious', 386, 9, '{"description": "Title track"}'),
    ('Heavyweight', 353, 9, '{"description": "Featuring Michelle Adamson"}'),
    ('Suliman', 454, 9, '{"description": "Orchestral psytrance"}');


-- Albums for The Prodigy
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('Experience', '1992-09-28', 4, '{"description": "Debut album"}'),
    ('The Fat of the Land', '1997-06-30', 4, '{"description": "Commercial breakthrough"}'),
    ('Invaders Must Die', '2009-02-23', 4, '{"description": "Return to the original sound"}');

-- Songs for The Prodigy's "Experience"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Jericho', 209, 10, '{"description": "Breakbeat anthem"}'),
    ('Music Reach (1/2/3/4)', 268, 10, '{"description": "Intro track"}'),
    ('Out of Space', 415, 10, '{"description": "Featuring Maxim Reality"}'),
    ('Everybody in the Place', 232, 10, '{"description": "Classic rave anthem"}'),
    ('Fire', 227, 10, '{"description": "Energy-packed track"}');

-- Songs for The Prodigy's "The Fat of the Land"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Smack My Bitch Up', 342, 11, '{"description": "Controversial hit"}'),
    ('Breathe', 355, 11, '{"description": "Featuring Maxim Reality"}'),
    ('Firestarter', 224, 11, '{"description": "Commercial success"}'),
    ('Serial Thrilla', 308, 11, '{"description": "Energetic track"}'),
    ('Fuel My Fire', 288, 11, '{"description": "Featuring Saffron"}');

-- Songs for The Prodigy's "Invaders Must Die"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Omen', 214, 12, '{"description": "Lead single"}'),
    ('Thunder', 280, 12, '{"description": "Aggressive track"}'),
    ('Take Me to the Hospital', 267, 12, '{"description": "Featuring Josh Homme"}'),
    ('Warrior''s Dance', 292, 12, '{"description": "Dancefloor anthem"}'),
    ('Invaders Must Die', 243, 12, '{"description": "Title track"}');


  -- Albums for Led Zeppelin
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('Led Zeppelin', '1969-01-12', 5, '{"description": "Debut album"}'),
    ('Led Zeppelin II', '1969-10-22', 5, '{"description": "Commercial success"}'),
    ('Led Zeppelin IV', '1971-11-08', 5, '{"description": "Iconic album with no official title"}');

-- Songs for Led Zeppelin's "Led Zeppelin"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Good Times Bad Times', 166, 13, '{"description": "Opening track"}'),
    ('Babe I''m Gonna Leave You', 353, 13, '{"description": "Folk-influenced track"}'),
    ('Dazed and Confused', 386, 13, '{"description": "Epic track with bow solo"}'),
    ('Communication Breakdown', 150, 13, '{"description": "Fast-paced rock"}'),
    ('How Many More Times', 482, 13, '{"description": "Bluesy track with medley"}');

-- Songs for Led Zeppelin's "Led Zeppelin II"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Whole Lotta Love', 334, 14, '{"description": "Hit single"}'),
    ('What Is and What Should Never Be', 285, 14, '{"description": "Blues rock"}'),
    ('Ramble On', 272, 14, '{"description": "Folk-influenced rock"}'),
    ('Heartbreaker', 248, 14, '{"description": "Guitar solo"}'),
    ('Bring It On Home', 331, 14, '{"description": "Blues rock with harmonica"}');

-- Songs for Led Zeppelin's "Led Zeppelin IV"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Black Dog', 294, 15, '{"description": "Hard rock anthem"}'),
    ('Rock and Roll', 220, 15, '{"description": "Energetic track"}'),
    ('Stairway to Heaven', 482, 15, '{"description": "Epic rock ballad"}'),
    ('Misty Mountain Hop', 278, 15, '{"description": "Rock track with keyboards"}'),
    ('When the Levee Breaks', 416, 15, '{"description": "Blues-influenced track"}');

-- Albums for The Notorious B.I.G.
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('Ready to Die', '1994-09-13', 6, '{"description": "Debut album"}'),
    ('Life After Death', '1997-03-25', 6, '{"description": "Posthumous double album"}'),
    ('Born Again', '1999-12-07', 6, '{"description": "Posthumous compilation album"}');

-- Songs for The Notorious B.I.G.'s "Ready to Die"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Intro', 3, 16, '{"description": "Opening track"}'),
    ('Things Done Changed', 201, 16, '{"description": "Reflective track"}'),
    ('Gimme the Loot', 266, 16, '{"description": "Hard-hitting lyrics"}'),
    ('Machine Gun Funk', 251, 16, '{"description": "Funky track"}'),
    ('Warning', 206, 16, '{"description": "Storytelling track"}');

-- Songs for The Notorious B.I.G.'s "Life After Death"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Life After Death (Intro)', 34, 17, '{"description": "Intro"}'),
    ('Somebody''s Gotta Die', 268, 17, '{"description": "Crime narrative"}'),
    ('Hypnotize', 226, 17, '{"description": "Hit single"}'),
    ('Kick in the Door', 239, 17, '{"description": "Diss track"}'),
    ('Mo Money Mo Problems', 239, 17, '{"description": "Featuring Puff Daddy and Mase"}');

-- Songs for The Notorious B.I.G.'s "Born Again"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Born Again', 203, 18, '{"description": "Title track"}'),
    ('Notorious B.I.G.', 227, 18, '{"description": "Featuring Lil'' Kim and Puff Daddy"}'),
    ('Dead Wrong', 214, 18, '{"description": "Featuring Eminem"}'),
    ('Hope You N****s Sleep', 317, 18, '{"description": "Featuring Hot Boys and Big Tmer"}'),
    ('Biggie', 162, 18, '{"description": "Tribute track"}');

-- Albums for Wu-Tang Clan
INSERT INTO albums (album_title, release_date, artist_id, other_album_data) VALUES
    ('Enter the Wu-Tang (36 Chambers)', '1993-11-09', 7, '{"description": "Debut album"}'),
    ('Wu-Tang Forever', '1997-06-03', 7, '{"description": "Double album"}'),
    ('The W', '2000-11-21', 7, '{"description": "Third studio album"}');

-- Songs for Wu-Tang Clan's "Enter the Wu-Tang (36 Chambers)"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Bring da Ruckus', 290, 19, '{"description": "Opening track"}'),
    ('Shame on a N****', 172, 19, '{"description": "Featuring ODB"}'),
    ('Clan in da Front', 294, 19, '{"description": "Classic Wu-Tang track"}'),
    ('Wu-Tang: 7th Chamber', 383, 19, '{"description": "Part I"}'),
    ('Can It Be All So Simple', 363, 19, '{"description": "Part II"}');

-- Songs for Wu-Tang Clan's "Wu-Tang Forever"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Wu-Revolution', 344, 20, '{"description": "Part I"}'),
    ('Reunited', 293, 20, '{"description": "Part II"}'),
    ('Triumph', 341, 20, '{"description": "Hit single"}'),
    ('It''s Yourz', 288, 20, '{"description": "Part III"}'),
    ('For Heaven''s Sake', 250, 20, '{"description": "Part IV"}');

-- Songs for Wu-Tang Clan's "The W"
INSERT INTO songs (song_title, duration, album_id, other_song_data) VALUES
    ('Protect Ya Neck (The Jump Off)', 258, 21, '{"description": "Hit single"}'),
    ('Careful (Click, Click)', 214, 21, '{"description": "Featuring ODB"}'),
    ('Hollow Bones', 206, 21, '{"description": "Part I"}'),
    ('Redbull', 239, 21, '{"description": "Part II"}'),
    ('One Blood Under W', 191, 21, '{"description": "Part III"}');


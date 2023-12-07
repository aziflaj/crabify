import os
from kafka import KafkaConsumer
import psycopg2
from cassandra.cluster import Cluster
import json
from song_events_handler import song_events_handler
from cdc_disliked_songs import disliked_songs_handler

topic = os.environ.get("KAFKA_TOPIC")
event_type = topic.split(".")[-1]
kafka_server = "kafka-service.kafka.svc.cluster.local:9092"

pgConn = psycopg2.connect(
    dbname='crabify',
    user='crabifyschrabify',
    password='password',
    host='postgres-service.default.svc.cluster.local',
    port='5432',
)

cassandraConn = Cluster(['cassandra.default.svc.cluster.local']).connect('song_events_ksp')

# Much dynamic, very wow
TOPIC_HANDLERS = {
    "song-events": song_events_handler,
    "disliked_songs": disliked_songs_handler,
    # "liked_songs": handle_liked_songs,
    # "liked_albums": handle_liked_albums,
    # "disliked_albums": handle_disliked_albums,
    # "artists_followed": handle_artists_followed,
    # "artists_unfollowed": handle_artists_unfollowed
}



def handle_message(event_type, message):
    print(f"Handling {event_type} event")
    decoded_message = json.loads(message.value.decode("utf-8"))
    TOPIC_HANDLERS[event_type](
        pgConn,
        cassandraConn,
        decoded_message
    )



if __name__ == "__main__":
    print(f"Starting consumer for {event_type}")
    consumer = KafkaConsumer(
        topic,
        bootstrap_servers=[kafka_server],
        enable_auto_commit=False
    )

    for message in consumer:
        handle_message(event_type, message)

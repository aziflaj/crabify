import os
from kafka import KafkaConsumer
from song_events_handler import song_events_handler

# Much dynamic, very wow
TOPIC_HANDLERS = {
    "song-events": song_events_handler,
    # "liked_songs": handle_liked_songs,
    # "disliked_songs": handle_disliked_songs,
    # "liked_albums": handle_liked_albums,
    # "disliked_albums": handle_disliked_albums
}


def handle_message(event_type, message):
    print("Received message from {}: {}".format(event_type, message))
    TOPIC_HANDLERS[event_type](message.value.decode("utf-8"))

if __name__ == "__main__":
    print("Starting consumer...")

    topic = os.environ.get("KAFKA_TOPIC")
    event_type = topic.split(".")[-1]
    kafka_server = "kafka-service.kafka.svc.cluster.local:9092"

    print("Listening to topic: {}".format(topic))
    print("Event type: {}".format(event_type))
    print("Kafka server: {}".format(kafka_server))

    consumer = KafkaConsumer(
        topic,
        bootstrap_servers=[kafka_server],
        enable_auto_commit=False
    )

    for message in consumer:
        handle_message(event_type, message)

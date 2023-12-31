# Crabify

_You either die Spotify, or you go through [carcinisation]([url](https://en.wikipedia.org/wiki/Carcinisation)) and become Crabify <sub>calling it crapify would be too on the nose</sub>_

\- Alan Turing, probably

> Disclaimer: The sole purpose of this repo is to be used in a **D**ata **E**ngineering and **A**rchitecture **D**emo - _DEAD_ - and should only be regarded as a Proof of Concept. The lack of replication here is on purpose, and the missing parts are left out as an exercise for the reader to add them.

<details>
<summary>Click here to see the Idealized System Design</summary>

![](https://github.com/aziflaj/crabify/blob/main/docs/crabify-perfect.png?raw=true)

</details>

<details>
<summary>Click here to see the Actual System Design</summary>

![](https://github.com/aziflaj/crabify/blob/main/docs/crabify-actual.png?raw=true)

</details>


## Deploying Kafka

Go to the `franz` folder and setup the Kafka broker:

> Upon further investigation, `sed` doesn't wanna play along on macOS. use `gsed` instead

```bash
$ kubectl apply -f 00-namespace.yml
$ kubectl apply -f 01-zookeeper.yml
$ kubectl apply -f 02-kafka.yml
$ cp 03-kafka-depl.tpl.yml 03-kafka-depl.yml

# Grab Zookeeper's internal IP
$ zooey_ip=$(kubectl get services -n kafka | grep zookeeper | awk '{ print $3 }')
$ sed -i "s/<ZOOKEEPER-INTERNAL-IP>/$zooey_ip/g" 03-kafka-depl.yml

# Grab Brokers's internal IP
$ brock_ip=$(kubectl get services -n kafka | grep kafka | awk '{ print $3 }')
$ sed -i "s/<KAFKA-BROKER-IP>/$brock_ip/g" 03-kafka-depl.yml

$ kubectl apply -f 03-kafka-depl.yml
```

## Deploying PG

Go to the `postgres` folder and run:

```bash
$ kubectl apply -f 00-postgres-service.yml
$ kubectl apply -f 01-postgres-deployment.yml
# TODO: wait until the pod is Running
$ pod_id=$(kubectl get pods | grep postgres | awk '{ print $1 }')
$ kubectl cp ./pgschema.sql $pod_id:var/lib/postgresql/data/pgschema.sql
$ kubectl cp ./pgseed.sql $pod_id:var/lib/postgresql/data/pgseed.sql
```

Then SSH into the pod and seed it up (also change WAL level, it's a surprise tool that will help us later):

```bash
$ kubectl exec -it $pod_id -- /bin/bash
#/ psql -U crabifyschrabify -d crabify -f var/lib/postgresql/data/pgschema.sql
#/ psql -U crabifyschrabify -d crabify -f var/lib/postgresql/data/pgseed.sql
#/ psql -U crabifyschrabify -d crabify -c "ALTER SYSTEM SET wal_level = logical"
# now log out of the postgres pod and restart it
$ kubectl rollout restart deployment postgres-depl
```

And voila, seeded db ready to use.

## Deploying the Go Producer

Go to the `guano` folder and build the Docker image:

```bash
$ docker build -t guano:latest .
```

Then deploy the pod:

```bash
$ kubectl apply -f 00-guano-deployment.yml
```

To see how the events are being generated:

```bash
$ pod_id=$(kubectl get pods | grep guano | awk '{ print $1 }')
$ kubectl logs -f $pod_id
```

At this point you should be having:
1. A Kafka service
2. A PostgreSQL DB serving music-streaming related data
3. A Go service simulating a music screaming backend, producing events both in DB (likes/dislikes, follows/unfollows) as well as in Kafka (song playing/skipped/paused)


you can see events produced in kafka by running:

```bash
$ kubectl -n kafka run kafka-consumer -ti \
    --image=quay.io/strimzi/kafka:0.38.0-kafka-3.6.0 \
    --rm=true --restart=Never -- \
    bin/kafka-console-consumer.sh \
        --bootstrap-server kafka-service:9092 \
        --topic song-events
```

## Setting up the CDC via Debezium

Go to the `debezium` directory and do the following:

```bash
$ kubectl apply -f 00-pg-connector.yml
$ kubectl apply -f 01-cdc.yml
```

Now, verify the Debezium connector is running as it should:

```bash
$ kubectl exec -it $(kubectl get pods | grep debezium-connector | awk '{print $1}') -- curl http://localhost:8083/connectors
```

It should respond with an empty array. Now run:

```bash
$ kubectl exec -it $(kgp | grep debezium-connector | awk '{print $1}') -- curl http://localhost:8083/connectors \
  -H "Accept:application/json" \
  -H "Content-Type:application/json" \
  -d '{
    "name": "pg-cdc",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": "postgres-service",
        "database.port": "5432",
        "database.user": "crabifyschrabify",
        "database.password": "password",
        "database.dbname": "crabify",
        "database.server.name": "postgresql",
        "plugin.name": "pgoutput",
        "table.include.list": "public.liked_songs,public.disliked_songs,public.artists_followed,public.liked_albums,public.disliked_albums",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "topic.prefix": "cdc_events"
    }
}'
```

It should respond with the same thing. Now, to list all the present Kafka topics:

```bash
$ broker_pod=$(kubectl get pods -n kafka | grep broker | awk '{print $1}')
$ kubectl -n kafka exec -it $broker_pod -- kafka-topics.sh --list --bootstrap-server kafka-service:9092
```

You should see something like this:

```
__consumer_offsets
cdc_events.public.artists_followed
cdc_events.public.disliked_songs
cdc_events.public.liked_songs
dbz-cdc-config
dbz-cdc-offset
dbz-cdc-status
song-events
```

## Deploying Cassandra sink

go to `cassandra` folder and run

```
$ kubectl apply -f 00-cassandra-deployment.yml
```
wait for the pod to deploy and start (you might need to read the pod logs) and then do

```
$ kubectl exec -it <cassandra-pod-name> -- cqlsh
```

Now in the shell:

```sql
CREATE KEYSPACE IF NOT EXISTS crabify_analytics WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE crabify_analytics;

CREATE TABLE IF NOT EXISTS song_events (
    event_type TEXT PRIMARY KEY,
    user_id INT,
    username TEXT,
    song_id INT,
    song_title TEXT,
    album_id INT,
    album_title TEXT,
    artist_id INT,
    artist_name TEXT,
    duration INT,
    created_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS playtime (
    artist_id INT,
    username TEXT,
    song_id INT,
    song_title TEXT,
    artist_name TEXT,
    duration INT,
    PRIMARY KEY (artist_id, username, song_id)
);
```

## Deploying the Python Consumer

Kafka is being consumed by a handful of Python pods. Go to `coprophage` and do the following:

```bash
# build the docker image
$ docker build -t coprophage:latest .

# deploy coprophages
$ kubectl apply -f 00-namespace.yml
$ kubectl apply -f 01-deployment.yml
```

Now you have one consumer per each Kafka topic, storing events in Cassandra.

## Analytics on Cassandra

Go to `catalogue` and set up the service:

```bash
$ docker build -t catalogue:latest .
$ kubectl apply -f 00-service.yml
$ kubectl apply -f 01-deployment.yml

# Find the correct service port
$ kubectl get svc catalogue-service
NAME                TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
catalogue-service   NodePort   10.103.250.110   <none>        4567:30355/TCP   5m24s
```

Read the `PORT(S)` and go to the mapped port, e.g. `http://localhost:30355`. You'll see analytics per each user

## Handouts to Artists

Go to `outpay` and set up the "payment" process:

```bash
docker buld -t outpay:latest .
kubectl apply -f 00-cron.yml
```

Now you have a cron job running every 5 seconds calculating the playtime seconds for each artist

# Crabify
-- _Because crappify is too obvious_

## Deploying :skull: Kafka :skull:

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

Then SSH into the pod and seed it up:

```bash
$ kubectl exec -it $pod_id -- /bin/bash
#/ psql -U crabifyschrabify -d crabify -f var/lib/postgresql/data/pgschema.sql
#/ psql -U crabifyschrabify -d crabify -f var/lib/postgresql/data/pgseed.sql
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

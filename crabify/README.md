# Crabify
-- _Because crappify is too obvious_

## Deploying PG

Go to the `postgres` folder and run:

```bash
$ kubectl apply -f postgres-deployment.yml
$ kubectl apply -f postgres-service.yml
$ pod_id=$(kgp | grep postgres | awk '{ print $1 }'
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
$ kubectl apply -f guano-deployment.yml
```

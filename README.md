
sudo add-apt-repository ppa:maxmind/ppa
sudo apt update
sudo apt install libmaxminddb0 libmaxminddb-dev mmdb-bin

# redpul

I have a great love for all things Reddit. It's a highly decentralized source of information from around the world. The 
API developers at Reddit built is also highly permissive - so much so that this project has yet to require credentials 
for authentication against Reddit servers. That's pretty neat.

### Current State

As of this writing, the primary flow of the data is simple. An R and Rust backend pulls the last 100 submissions from 
r/all. Then we determine which subreddits the submissions belong to, and also pull 100 of the last posts from each of those.

For example, suppose we pull a post from r/pics and r/politics on r/all, we now know that the subreddits r/pics and 
r/politics exist, so we can now go and retrieve their posts. I also store the last time a subreddit was polled as to prevent
frequent calls to high volume subreddits. If a subreddit has been pulled in the prior hour, it is skipped. The state of 
which is stored in Redis. 

This entire process is initiated with just one command and access credentials are in the .env file that is attached to 
this project. 

### About State
I think I have a unique way of managing it. And I need to write this out as something of a meditation.

### Prerequisites
* make
* docker
* docker-compose

### Building

For convenience, a Makefile exists to run common shell commands. To see the actual docker commands, feel free to explore 
the Makefile in the root directory. 

* `make build`
* `make up`
* `make down`

When the application is running after executing `make up` successfully, you have access to Postgres,
Redis, RabbitMQ, and Shiny

__Postgres__
* username: `postgres`
* password: `docker`
* database: `postgres`
* port: `5432`
* host: `localhost` (within container communication use `postgres`)

__Redis__
* username: none
* password: none
* port: `6379` 
* host: `localhost` (within container communication use `redis`)

__RabbitMQ__
* username: `guest`
* password: `guest`
* port: `5672` 

You can access the Redis landing page at
* `localhost:15672`

## Backing up Data (Incomplete)

The following command when run will export data to `./volumes/postgres/backup` _outside_ of 
the container. 

```
docker exec -it postgres bash -c '/usr/bin/pg_dump -h localhost -p 5432 -Fc -v -U $POSTGRES_USER $POSTGRES_DB > /data/postgres.bak'
```

# Docker container and docker compose demo

Hello World PHP is a single docker container built with a dockerfile to run a simple index PHP with hello world

DockerCompose has a compose file to build 2 containers that communicate
API container running python flask to return an JSON list and webserver container to call the API container and list the JSON


## Hello world PHP

### Image used 

https://hub.docker.com/_/php


### build cmd


docker *argument* *image name* *path to dockerfile*

docker build -t hello-world .


### run cmd


*foreground running no volume*
docker run -p 80:80 hello-world

*running with volume map*
*terminal needs to be in the local src dir for pwd to get the right path*

docker run -p 80:80 -v "$(pwd):/var/www/html"  hello-world

### stop and remove all 

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)


## Docker Compose

*run in the same dir as docker compose file*

docker-compose up
docker-compose up -d < run in the background

*test*
localhost:5001  < api
localhost:5000  < website

can now add extra items to the api.py



## Notes

The containers in the compose file have an network auto created when the compose file is run allowing the containers to communicate based on the names of the containers

To delete all containers including its volumes use,

docker rm -vf $(docker ps -a -q)
To delete all the images,

docker rmi -f $(docker images -a -q)



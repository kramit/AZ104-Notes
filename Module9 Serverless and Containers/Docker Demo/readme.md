# Hello world PHP

### Image used 

https://hub.docker.com/_/php


### build cmd


docker *argument* *image name* *path to dockerfile*

docker build -t hello-world .


### run cmd


*foreground running no volume*
docker run -p 80:80 hello-world

*running with volume map*


docker run -p 80:80 -v "$(pwd):/var/www/html"  hello-world

### stop and remove all 

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

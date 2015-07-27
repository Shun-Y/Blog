#!/bin/bash

docker-compose run --rm --no-deps web stack clean && docker-compose run --rm --no-deps web stack build && docker-compose run --rm --no-deps web stack install
sudo docker-compose build --no-cache web
docker tag -f blog_web:latest shuny/blog_web:latest
docker images
docker login
docker push shuny/blog_web:latest

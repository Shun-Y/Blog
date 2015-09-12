#!/bin/bash

sudo docker-compose build web
docker tag -f blog_web:latest shuny/blog_web:latest
docker push shuny/blog_web:latest

#!/bin/sh


docker login --username=_ --password=$(heroku auth:token) registry.heroku.com

docker tag \
 	dgoldstein1/links-heroku-graphapi-twowaykv:latest \
 	registry.heroku.com/graphapi-twowaykv-dev/web

docker push registry.heroku.com/graphapi-twowaykv-dev/web

heroku container:release web --app graphapi-twowaykv-dev
#!/bin/sh

# build image

docker build . \
	-t dgoldstein1/links-heroku-graphapi-twowaykv:latest

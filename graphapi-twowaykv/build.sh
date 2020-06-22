#!/bin/sh

set -euf -o pipefail

# build image

docker build . \
	-t dgoldstein1/links-heroku-graphapi-twowaykv:latest

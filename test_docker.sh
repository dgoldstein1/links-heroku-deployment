#!/bin/sh



docker run \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e READ_S3=true \
	-e WRITE_S3=false \
	-e AWS_SYNC_DIRECTORY="s3://links-deployment-dev/local-testing/" \
	-e GRAPH_SAVE_INTERVAL=20 \
	-e PORT=8443 \
	-p 8443:8443 \
	dgoldstein1/links-heroku-graphapi-twowaykv:latest
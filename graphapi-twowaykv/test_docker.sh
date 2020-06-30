#!/bin/sh



docker run \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e READ_S3=true \
	-e WRITE_S3=true \
	-e AWS_SYNC_DIRECTORY="s3://links-deployment-dev/local-testing/" \
	-p 5000:5000 \
	dgoldstein1/links-heroku-graphapi-twowaykv:latest
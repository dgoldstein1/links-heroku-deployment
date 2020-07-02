#!/bin/sh

set -e

# run all three
# - https://github.com/dgoldstein1/twowaykv on 5001
# - https://github.com/dgoldstein1/graphapi on 5000
# - https://github.com/dgoldstein1/reverse-proxy on $PORT

# init app configs
init() {
	touch logs.txt
}

# runs graphapi
start_graphapi() {
	mkdir -p $(dirname $GRAPH_SAVE_PATH)
	touch $GRAPH_SAVE_PATH
	cd /usr/graphApi
	flask run --host=0.0.0.0 --port 5002
	fail "graphapi"
}

start_twowaykv() {
	mkdir -p /data/twowaykv/
	unset PORT
	/usr/twowaykv/twowaykv serve
	fail "twowaykv"
}

start_reverseproxy() {
	/usr/reverseproxy/reverseproxy
	fail "reverseproxy"
}

sync_s3() {
	echo "syncing with s3"
	aws s3 sync /data $AWS_SYNC_DIRECTORY
}

sync_s3_loop() {
	# read in before there is any
	ENDPOINT="$biggraph_outgoing_url/save"
	while true; do
		sleep $GRAPH_SAVE_INTERVAL
		curl -s $ENDPOINT | wc -c
		sync_s3
	done

}

# service has failed
# $1 = service name
fail() {
	echo "-------------------------------" >>logs.txt
	echo "------------ $1 failure -------" >>logs.txt
	echo "-------------------------------" >>logs.txt
}

# graphapi
export GRAPH_SAVE_PATH=/data/graphapi/current_graph.graph
export biggraph_incoming_path=/services/biggraph/
export biggraph_outgoing_url="http://localhost:5002"
# twowaykv
export GRAPH_DOCS_DIR=/usr/twowaykv/docs/*
export GRAPH_DB_STORE_DIR=/data/twowaykv
export GRAPH_DB_STORE_PORT=5001
export twowaykv_incoming_path="/services/twowaykv/"
export twowaykv_outgoing_url="http://localhost:5001"
# links-ui
export links_incoming_path=/
export links_outgoing_url=file:///static-files
export lookup_incoming_path=/services/dev/wiki/
export lookup_outgoing_url=https://en.wikipedia.org
# reverse proxy
export services="twowaykv,biggraph,links,lookup"
# sync s3
# export GRAPH_SAVE_INTERVAL=10
# export READ_S3=false
# export WRITE_S3=false
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=
# export AWS_SYNC_DIRECTORY=

# start jobs
init
if [ "$READ_S3" = "true" ]; then
	sync_s3 
fi
if [ "$WRITE_S3" = "true" ]; then
	sync_s3_loop >logs.txt &
fi
start_graphapi &
start_twowaykv &
start_reverseproxy &

printenv
tail -f logs.txt

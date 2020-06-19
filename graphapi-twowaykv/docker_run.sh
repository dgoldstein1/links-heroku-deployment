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
	cd /usr/graphapi
	mkdir -p /data/graphapi/
	flask run --host=0.0.0.0 --port 5000
}

start_twowaykv() {
	cd /usr/twowaykv
	mkdir -p /data/twowaykv/
	/usr/twowaykv/twowaykv serve
}

# graphapi
export GRAPH_SAVE_PATH=/data/graphapi/current_graph.graph
# twowaykv
export GRAPH_DOCS_DIR=/usr/twowaykv/docs/*
export GRAPH_DB_STORE_DIR=/data/twowaykv

# start jobs
init
start_graphapi > logs.txt &
start_twowaykv > logs.txt &

printenv
tail -f logs.txt


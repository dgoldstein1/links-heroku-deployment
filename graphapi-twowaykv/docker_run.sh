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
	fail "graphapi"
}

start_twowaykv() {
	mkdir -p /data/twowaykv/
	/usr/twowaykv/twowaykv serve
	fail "twowaykv"
}

start_reverseproxy() {
	/usr/reverseproxy/reverseproxy
	fail "reverseproxy"
}

# service has failed
# $1 = service name
fail() {
	echo "-------------------------------" >> logs.txt
	echo "------------ $1 failure -------" >> logs.txt
	echo "-------------------------------" >> logs.txt
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
start_reverseproxy > logs.txt &

printenv
tail -f logs.txt


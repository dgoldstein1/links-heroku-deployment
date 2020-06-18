#!/bin/sh

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
	cd /urs/graphapi
	export GRAPH_SAVE_PATH=/data/graphapi/current_graph.graph
	flask run --host=0.0.0.0 --port 5000
}

# start jobs
init
start_graphapi > logs.txt &

printenv
tail -f logs.txt


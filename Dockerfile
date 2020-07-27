# creates dockerfile merging:
# - https://github.com/dgoldstein1/twowaykv
# - https://github.com/dgoldstein1/graphapi
# - https://github.com/dgoldstein1/reverse-proxy

# Copy everything into a commonn container
FROM dgoldstein1/links:2.2.1 AS links
FROM dgoldstein1/reverse-proxy:0.1.5 AS reverseproxy
FROM dgoldstein1/twowaykv:1.0.1 AS twowaykv
FROM dgoldstein1/biggraph:2.0.2 AS biggraph

# configure graphapi
RUN mkdir -p /usr/graphapi

# configure twowaykv
RUN mkdir -p /usr/twowaykv/docs
COPY --from=twowaykv /bin/twowaykv /usr/twowaykv/twowaykv
COPY --from=twowaykv /docs/index.html /usr/twowaykv/docs/index.html

# configure graphapi
RUN mkdir -p /usr/reverseproxy/
COPY --from=reverseproxy /go/src/dgoldstein1/reverseProxy/reverseProxy /usr/reverseproxy/reverseproxy

# configure links-ui
COPY --from=links /static-files/ /static-files/
COPY links-config.json /static-files/config.json

# execution
ADD VERSION /usr/VERSION
ENV GRAPH_SAVE_INTERVAL 120
ADD docker_run.sh /usr/docker_run.sh
CMD /usr/docker_run.sh

# creates dockerfile merging:
# - https://github.com/dgoldstein1/twowaykv
# - https://github.com/dgoldstein1/graphapi
# - https://github.com/dgoldstein1/reverse-proxy

# Copy everything into a commonn container
FROM dgoldstein1/reverse-proxy:latest AS reverseproxy
FROM dgoldstein1/twowaykv:latest AS twowaykv
FROM dgoldstein1/biggraph:latest AS biggraph

# configure graphapi
RUN mkdir -p /usr/graphapi

# configure twowaykv
RUN mkdir -p /usr/twowaykv/docs
COPY --from=twowaykv /bin/twowaykv /usr/twowaykv/twowaykv
COPY --from=twowaykv /docs/index.html /usr/twowaykv/docs/index.html

# configure graphapi
RUN mkdir -p /usr/reverseproxy/
COPY --from=reverseproxy /go/src/dgoldstein1/reverseProxy/reverseProxy /usr/reverseproxy/reverseproxy

# execution
ADD VERSION /usr/VERSION
ADD docker_run.sh /usr/docker_run.sh
CMD /usr/docker_run.sh

# creates dockerfile merging:
# - https://github.com/dgoldstein1/twowaykv
# - https://github.com/dgoldstein1/graphapi
# - https://github.com/dgoldstein1/reverse-proxy

# Copy everything into a commonn container
FROM dgoldstein1/reverse-proxy:latest AS revproxy
FROM dgoldstein1/twowaykv:latest AS twowaykv
FROM dgoldstein1/biggraph:latest AS biggraph

# configure twowaykv
RUN mkdir -p /usr/twowaykv
RUN mkdir -p /usr/twowaykv/docs
COPY --from=twowaykv /bin/twowaykv /usr/twowaykv/twowaykv
COPY --from=twowaykv /docs/index.html /usr/twowaykv/docs/index.html

# execution
ADD docker_run.sh .
CMD ./docker_run.sh

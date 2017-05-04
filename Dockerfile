FROM alpine:latest

ARG CONFD_VERSION
ENV CONFD_VERSION ${CONFD_VERSION:-0.11.0}
ARG DUMB_INIT_VERSION
ENV DUMB_INIT_VERSION ${DUMB_INIT_VERSION:-1.2.0}
ENV PATH /bin/:$PATH
COPY entrypoint.sh /entrypoint.sh
RUN apk add --no-cache bash curl git && \
    apk add --no-cache --virtual .confd-dependencies go gcc make bash musl-dev && \
    git clone https://github.com/kelseyhightower/confd.git /src/confd && \
    cd /src/confd && \
    git checkout -q --detach "v$CONFD_VERSION" && \
    cd /src/confd/src/github.com/kelseyhightower/confd && \
    GOPATH=/src/confd/vendor:/src/confd go build . && \
    mv ./confd /bin/ && \
    chmod +x /bin/confd && \
    mkdir /etc/confd && \
    git clone https://github.com/Yelp/dumb-init /src/dumb-init && \
    cd /src/dumb-init && \
    git checkout -q --detach "v$DUMB_INIT_VERSION" && \
    make && \
    mv ./dumb-init /bin/ && \
    chmod +x /bin/dumb-init && \
    apk del .confd-dependencies && \
    rm -rf /src && \
    chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
VOLUME /etc/confd/
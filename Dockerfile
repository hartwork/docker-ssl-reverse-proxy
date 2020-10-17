# Copyright (C) 2018 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GNU Affero GPL v3 or later

# NOTE Keep default tag in sync with docker-compose.yml
ARG CADDY_TAG=1.0.3
FROM abiosoft/caddy:${CADDY_TAG}

# Install system upgrades
RUN apk update \
        && \
    apk upgrade

# Install build dependencies
RUN apk update \
        && \
    apk add \
            libcap \
            libcap-ng-utils \
            shadow

# Allow Caddy to bind to :80 and :433 as unprivileged user
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy \
        && \
    filecap /usr/bin/caddy

# Create nobody-like user for caddy
RUN useradd \
        --create-home \
        --home-dir /home/caddy/ \
        --non-unique --uid 65534 --gid 65534 \
        -K MAIL_DIR=/var/empty \
        caddy
RUN chmod 0700 /home/caddy/
ENV HOME=/home/caddy/
VOLUME /home/caddy/

# Uninstall direct build dependencies
RUN apk del libcap libcap-ng libcap-ng-utils linux-pam shadow

# Wipe apk cache
RUN rm -fv /var/cache/apk/*

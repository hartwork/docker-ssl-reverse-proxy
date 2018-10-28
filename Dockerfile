# Copyright (C) 2018 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GNU Affero GPL v3 or later

ARG CADDY_TAG=latest
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

# Allow Caddy to bind to :80 and :433 as nobody:nogroup
RUN setcap cap_net_bind_service=+ep /usr/bin/caddy \
        && \
    filecap /usr/bin/caddy

# Give nobody a home
RUN mkdir -m 0700 /home/nobody/
RUN chown nobody:nogroup /home/nobody/
RUN usermod --home /home/nobody/ nobody

# Uninstall direct build dependencies
RUN apk del libcap libcap-ng libcap-ng-utils linux-pam shadow

# Wipe apk cache
RUN rm -fv /var/cache/apk/*

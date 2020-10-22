#! /usr/bin/env bash
# Copyright (C) 2020 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GNU Affero GPL v3 or later

stdbuf --output=L fgrep '"logger":"http.log.access.log' \
    | stdbuf --output=L jq -r '. | (.request.host // "-") + " " + .common_log + " \"" + (.request.headers.Referer // ["-"])[0] + "\" \"" + (.request.headers."User-Agent" // ["-"])[0] + "\""'

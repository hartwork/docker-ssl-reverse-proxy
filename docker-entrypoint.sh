#! /usr/bin/env bash
# Copyright (C) 2020 Sebastian Pipping <sebastian@pipping.org>
# Licensed under GNU Affero GPL v3 or later

set -e

# The idea is this:
# - Have Caddy produce JSON-line log output
# - Duplicate Caddy's stdout
# - On that duplicate:
#   - Drop everything but access log
#   - Transform access log lines from JSON into something
#     more friendly to the human eye
#
# To do that we make use of tee(1) and a named pipe.
# The reader must start reading first or else the writer
# would be blocked forever.

stdout_copy_pipe="$(mktemp -d)/stdout"
mkfifo "${stdout_copy_pipe}"

/format-caddy-json-access-log.sh < "${stdout_copy_pipe}" &

(set -x; "$@") | tee "${stdout_copy_pipe}"

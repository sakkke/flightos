#!/bin/sh
set -eu
temp_bin="$(mktemp -d)"
mkdir "$temp_bin"
trap "rm -fr \"$temp\"" EXIT
FLIGHTOS="$temp/flightos"
FLIGHTOS_URL=https://github.com/sakkke/flightos/releases/download/2022.11.4/flightos-2022.11.4.tar.gz
FZF_URL=https://github.com/junegunn/fzf/releases/download/0.35.0/fzf-0.35.0-linux_arm64.tar.gz
curl -Ls "$FLIGHTOS_URL" | tar -zxf - -C "$temp_bin"
if ! type fzf 2>&1 > /dev/null; then
    curl -Ls "$FZF_URL" | tar -zxf - -C "$temp_bin"
fi
PATH="$PATH:$temp_bin" "$FLIGHTOS" "$@"

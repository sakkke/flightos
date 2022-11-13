#!/bin/sh
set -eu
temp="$(mktemp -d)"
temp_bin="$temp/bin"
mkdir "$temp_bin"
trap "rm -fr \"$temp\"" EXIT
FLIGHTOS="$temp/flightos"
FLIGHTOS_URL=https://github.com/sakkke/flightos/releases/download/2022.11.0/flightos
FZF_URL=https://github.com/junegunn/fzf/releases/download/0.35.0/fzf-0.35.0-linux_arm64.tar.gz
curl -Lso "$FLIGHTOS" "$FLIGHTOS_URL"
chmod +x "$FLIGHTOS"
if ! type fzf 2>&1 > /dev/null; then
    curl -Ls "$FZF_URL" | tar -zxf - -C "$temp_bin"
fi
PATH="$PATH:$temp_bin" "$FLIGHTOS" "$@"

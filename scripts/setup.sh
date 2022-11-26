#!/bin/sh
set -eu
temp="$(mktemp -d)"
temp_bin="$temp/bin"
mkdir "$temp_bin"
trap "rm -fr \"$temp\"" EXIT
ver="$(curl -s https://raw.githubusercontent.com/sakkke/flightos/${FLIGHTOS_SETUP_BRANCH:-main}/version.txt)"
FLIGHTOS="$temp/flightos"
FLIGHTOS_URL="https://github.com/sakkke/flightos/releases/download/$ver/flightos-$ver.tar.gz"
FZF_URL=https://github.com/junegunn/fzf/releases/download/0.35.1/fzf-0.35.1-linux_amd64.tar.gz
curl -Ls "$FLIGHTOS_URL" | tar -zxf - -C "$temp_bin"
if ! type fzf > /dev/null 2>&1; then
    curl -Ls "$FZF_URL" | tar -zxf - -C "$temp_bin"
fi
PATH="$temp_bin:$PATH" flightos "$@"

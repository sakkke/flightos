#!/bin/sh
set -eu
temp="$(mktemp -d)"
trap "rm -fr \"$temp\"" EXIT
FLIGHTOS="$temp/flightos"
FLIGHTOS_URL=https://github.com/sakkke/flightos/releases/download/2022.11.0/flightos
curl -Lso "$FLIGHTOS" "$FLIGHTOS_URL"
chmod +x "$FLIGHTOS"
"$FLIGHTOS" "$@"

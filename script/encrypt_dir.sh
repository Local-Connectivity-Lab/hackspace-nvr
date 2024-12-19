#!/bin/bash
set -euo pipefail

original="$1" ; shift
outfile="$original.gpgtar"

pushd $(dirname $(dirname $0)) > /dev/null
latest_counsel="$(basename $(ls -d keys/Counsel* | tail -n 1))"
popd > /dev/null

gpgtar --encrypt --recipient "$latest_counsel" --output "$outfile" "$original"

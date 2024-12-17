#!/bin/bash
set -euo pipefail

pushd $(dirname $(dirname $0)) > /dev/null

file="$1"; shift

if [[ "$file" = *.gpgtar ]] ; then
	export GPG_TTY=$(tty)
	directory="${file%.gpgtar}"
	directory="$(dirname "$file")"
	gpgtar --directory . --decrypt "$file"
else
	echo "The target file must match *.gpgtar"
	exit 1
fi

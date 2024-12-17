#!/bin/bash
set -euo pipefail

target="$1"; shift
count="$(cat "$target/required")"

for name in $@; do
	for file in $(ls "$target"/*"$name"*.gpg); do
		gpg -q --decrypt "$file" > "${file%.gpg}"
	done
done

if [[ $(ls -1 "$target"/*.split | wc -l) -ge "$count" ]] ; then
	cat "$target"/*.split | ssss-combine -q -t $count 2> "$target/password" \
		&& ( echo "Wrote password to $target/password" ) \
		|| ( echo "Failed to combine secrets!"; exit 1 )
else
	echo "Please unlock more secrets"
	echo "found these, but expected $count:"
	ls -1 $target/*.split
	exit 2
fi

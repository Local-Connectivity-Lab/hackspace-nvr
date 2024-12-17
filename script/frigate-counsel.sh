#!/bin/bash
set -euo pipefail
pushd $(dirname $(dirname $0)) > /dev/null

password="$(diceware)"
required="$1"; shift
total=$#
label="$(date +%Y%m%d)"
user="CounselOf$label"

gpg --batch --passphrase "$password" --quick-gen-key "$user"

keydir="keys/$user"
mkdir -p "$keydir"
echo "$required" > "$keydir/required"

for token in $(echo "$password" | ssss-split -n "$total" -t "$required" -w "$label" -q); do
	name="$1"; shift
	encrypted_token_file="$keydir/${label}-${name}.split.gpg"
	echo $token | gpg --encrypt --recipient "$name" --armor > "$encrypted_token_file"
done


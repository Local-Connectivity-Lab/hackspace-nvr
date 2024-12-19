#! /bin/bash
set -euo pipefail
pushd $(dirname $(dirname $0)) > /dev/null

# Fix Frigate file permissions
docker exec frigate chmod -R a+wr /media

# Delete preview files
find media/frigate/clips/previews -type f -mmin +60 -delete

# Delete directories older than retention policy
recordings=media/frigate/recordings
find $recordings -mtime +14 -delete

# Encrypt everything older than 1 hour
hour_dirs_only="-mindepth 2 -maxdepth 2 -type d"
older_than_1h="-mmin +60"
for hour in $(find $recordings $hour_dirs_only $older_than_1h); do
	./script/encrypt_dir.sh "$hour"
	rm -rf "$hour"
done

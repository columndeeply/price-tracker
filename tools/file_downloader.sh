#!/usr/bin/env sh
# Downloads a URL using wget
# It retries on 503 and uses a random useragent each time

# Source the config file
. "$(dirname "$0")/../data/config.sh"

# Set the filename
file="$logs/$(date +%Y%m%d%H%M%S)_$(uuidgen)_$(date +%N).html"

# Headers
header="Accept: text/html,application/xhtml+xml,application/xml;q=-1.9,*/*;q=0.8"

# Download the file (only retry 20 times)
retries=0
wget --retry-on-http-error=503 --waitretry=3 --quiet -U "$(shuf -n 1 "$useragents")" --header="$header" --header="DNT: 1" "$1" -O "$file"
while [ -n "$(grep 'To discuss automated access' "$file")" ] || [ ! -s "$file" ]; do
	[ "$retries" -eq "$max_retries" ] && exit || retries=$((retries + 1))

	sleep "$wait_time"

	wget --retry-on-http-error=503 --waitretry=2 --quiet -U "$(shuf -n 1 "$useragents")" --header="$header" --header="DNT: 1" "$1" -O "$file"
done

# Return the full path to the downloaded file
readlink -f "$file"

#!/usr/bin/env sh
# Toggler script. It decides whether to add or delete a product

# Source the config file
. "$(dirname "$0")/data/config.sh"

# Cleanup the URL a bit
url="$(sh $url_cleaner "$1")"

# Check if the URL already exists
exists="$(sqlite3 "$db" "SELECT id FROM urls WHERE url = '$url';")"
[ -z "$exists" ] && sh "$add_script" "$url" && echo "Added"
[ -n "$exists" ] && sh "$remove_script" "$exists" && echo "Removed"

#!/usr/bin/env sh
# Add URL to the DB

# Source the config file
. "$(dirname "$0")/data/config.sh"

# Get current date
now="$(date '+%d-%m-%Y %H:%M:%S')"

# Get the parser
parser="$(echo "$1" | awk -F[/:] '{print $4}' | tr -cd '[:alnum:]')"

# Run the parser on this URL
result="$(sh "$parsers_folder/$parser".sh "$1")"

# Get the product title and price
title="$(echo "$result" | grep "title/" | cut -d/ -f 2)"
price="$(echo "$result" | grep "price/" | cut -d/ -f 2 | sed -e 's/,/./g' -e 's/[^0-9.]*//g')"

# Save the product and get the assigned ID
new_id="$(sqlite3 "$db" "INSERT INTO urls (title, url, created) VALUES ('$title', '$1', '$now'); SELECT MAX(id) FROM urls;")"

# Add price to the DB
sqlite3 "$db" "INSERT INTO prices (url_id, price, created) VALUES ('$new_id', '$price', '$now');"

#!/usr/bin/env sh
# Checks all products in the DB for changes
# This script should be set as a cronjob to check the products automatically

# Source the config file
. "$(dirname "$0")/data/config.sh"

# Loop through all products
sqlite3 "$db" 'SELECT id FROM urls ORDER BY title' | while read -r id; do
	# Get current date
	now="$(date '+%d-%m-%Y %H:%M:%S')"

	# Get the last known price
	price="$(sqlite3 "$db" 'SELECT price FROM prices WHERE url_id = '$id' ORDER BY id DESC LIMIT 1;')"

	# Get the URL
	url="$(sqlite3 "$db" 'SELECT url FROM urls WHERE id = '$id';')"
	[ -z "$url" ] && exit

	# Get the parser
	parser="$(echo "$url" | awk -F[/:] '{print $4}' | tr -cd '[:alnum:]')"

	# Run parser
	result="$(sh "$parsers_folder/$parser".sh "$url")"

	# Get the title, new price and the extras
	title="$(echo "$result" | grep "title/" | cut -d/ -f 2)"
	new_price="$(echo "$result" | grep "price/" | cut -d/ -f 2)"
	extras="$(echo "$result" | grep "extras/" | cut -d/ -f 2)"

	# If the price is different save the new one and call the change checker script
	old="$(echo "$price" | sed -e 's/,/./g' -e 's/[^0-9.]*//g')"
	new="$(echo "$new_price" | sed -e 's/,/./g' -e 's/[^0-9.]*//g')"
	if [ "$old" != "$new" ]; then
	       sqlite3 "$db" "INSERT INTO prices (url_id, price, created) VALUES ('$id', '$new_price', '$now');"
	       sh "$change_checker" "$price" "$new_price" "$title" "$extras" "$url"
	fi
done

if [ "$debug" -gt 0 ]; then
	path="$logs/$(date +%Y%m%d%H%M)/"
	mkdir -p "$path"
	mv "$logs/"*html "$path"
fi

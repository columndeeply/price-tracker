#!/usr/bin/env sh
# Remove URL from the DB
# This script is called from the toggle script if the URL was already in the DB

# Source the config file
. "$(dirname "$0")/data/config.sh"

# Delete all rows with the URL id
sqlite3 "$db" "DELETE FROM urls WHERE id = '$1'; DELETE FROM prices WHERE url_id = '$1';"

#!/usr/bin/env sh
# Checks whether a price has changed or not
# If the price is lower than before send a notification, otherwise, do nothing

# Source the config file
. "$(dirname "$0")/../data/config.sh"

# Cleanup the prices. bc only accepts dots as decimal separators
old="$(echo "$1" | sed -e 's/,/./g' -e 's/[^0-9.]*//g')"
new="$(echo "$2" | sed -e 's/,/./g' -e 's/[^0-9.]*//g')"

# If either price is empty then set it to 0
[ "$old" = "" ] && old="0"
[ "$new" = "" ] && new="0"

# If the price went up exit the script, we only want to be notified when the price drops
[ "$old" != 0 ] && [ "$(echo "$old > $new" | bc -l)" -eq 0 ] && exit

# If there's any extra info add it to the message
[ -n "$4" ] && extras="$(printf '\n\n%s' "$4")"

# Fix &amp; in some titles
title="$(echo "$3" | sed 's/\&amp;/\&/g')"

# Build the message
msg="$(printf '%s\n\n%s -> %s%s\n\n%s' "$title" "$1" "$2" "$extras" "$5")"

# Send the text to the notifier script
sh "$notifier" "$msg"

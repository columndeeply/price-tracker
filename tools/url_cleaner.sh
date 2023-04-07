#!/usr/bin/env sh
# Cleanup URLs before adding them to the database to avoid duplicates

url="$1"
case "$url" in
	*"demo.ecommercehtml.com"*)
		# Remove everything after the ?
		url="$(echo "$url" | sed '#?.*##')"
		;;
esac

echo "$url"

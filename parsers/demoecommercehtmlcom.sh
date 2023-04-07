#!/usr/bin/env sh
# demo.ecommercehtml.com parser

# Source the config file
. "$(dirname "$0")/../data/config.sh"

# Download the URL
file="$(sh "$file_downloader" "$1")"

# Get the product title
title="$(pup '.product-details-style-1 h2.title text{}' < "$file")"
[ -n "$title" ] && title="$(echo "$title" | tr -d '\n')"

# Get the price
price="$(pup '.product-details-style-1 p.sale-price text{}' < "$file")"
[ -n "$price" ] && price="$(echo "$price" | tr -d '\n')"

# Get the product availability
extras="Original price: $(pup '.product-details-style-1 p.regular-price text{}' < "$file")"

# If not in debug mode remove the file
[ "$debug" -gt 0 ] || rm "$file"

# Return the product data
echo "title/$title"
echo "price/$price"
echo "$extras" | while read -r line; do
	echo "extras/$line"
done 

#!/usr/bin/env sh
# Generic notifier. Configure it as you wish.
# It's called by the change_checker script if the price is lower than before

echo "$1" | go-sendxmpp "example@example.org"

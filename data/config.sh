#!/usr/bin/env sh
# This file has all the variables used in the other scripts. It should be sourced at the beginning of each script

# Make sure that all the packages are installed before running
[ -z "$(command -v sqlite3)" ] && printf "%s\n" "Make sure that sqlite3 is installed" && error=1
[ -z "$(command -v pup)" ] && printf "%s\n" "Make sure that pup is installed" && error=1
[ -z "$(command -v bc)" ] && printf "%s\n" "Make sure that bc is installed" && error=1

[ "$error" = "1" ] && exit

# Set the project root
root="$HOME/price-tracker"

# Files and folders
db="$root/data/database.db"
useragents="$root/data/useragents"
parsers_folder="$root/parsers"
logs="$root/logs/"

# Scripts
file_downloader="$root/tools/file_downloader.sh"
notifier="$root/tools/notifier.sh"
change_checker="$root/tools/change_checker.sh"
add_script="$root/add.sh"
remove_script="$root/remove.sh"
url_cleaner="$root/tools/url_cleaner.sh"

# Misc
debug="0"
max_retries="20"
wait_time="2"

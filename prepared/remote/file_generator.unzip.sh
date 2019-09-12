#!/bin/bash

timestamp="$1"
wp_production_dir="$2"

local_user_home_dir=$(eval echo "~")
local_working_dir="$local_user_home_dir/.wordpress-staging-publisher/$timestamp"
production_dir="$local_working_dir/production"
console_dir="$local_working_dir/console"

# Go to the parent directory of the wordpress installation
cd "$wp_production_dir/"
zip -o -r "$console_dir/wordpress.archive.$timestamp.zip" ./* > /dev/null

# Remove the contents of the directory before putting the contents
# Uncomment the below statement for this to function
# rm -r $wp_production_dir/*

# Put the contents to the wordpress directory for production
unzip -o "$production_dir/wordpress.zip" -d "$wp_production_dir" > /dev/null
#!/bin/bash

timestamp="$1"
wp_staging_dir="$2"
staging_user_home_dir=$(eval echo "~")

local_user_home_dir=$(eval echo "~")
local_working_dir="$local_user_home_dir/.wordpress-staging-publisher/$timestamp"
production_dir="$local_working_dir/production"
console_dir="$local_working_dir/console"

mysql < "$console_dir/preparatory.sql"
mysql < "$production_dir/database.sql"
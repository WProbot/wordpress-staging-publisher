#!/bin/bash
# This script publishes the staging environment into its production environment.
# Copyright (C) 2019  Abel Callejo, International Rice Research Institute (a.callejo@irri.org)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see https://www.gnu.org/licenses/gpl-3.0.html.

clear

source "config/staging/install.conf"
wp_staging_user_name="$machine_username"
wp_staging_machine_name="$machine_hostname"
wp_staging_dir="$wordpress_dir"
search="$base_site_url"

source "config/production/install.conf"
wp_production_user_name="$machine_username"
wp_production_machine_name="$machine_hostname"
wp_production_dir="$wordpress_dir"
replace="$base_site_url"

timestamp=$(TZ=Asia/Manila date +"%Y-%m-%dT%H.%M.%SZ")

# Record the directory of the main script
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

local_user_home_dir=$(eval echo "~")
local_working_dir="$local_user_home_dir/.wordpress-staging-publisher/$timestamp"
staging_dir="$local_working_dir/staging"
production_dir="$local_working_dir/production"
console_dir="$local_working_dir/console"

# Prepare the working area inside the local machine
mkdir -p "$local_user_home_dir/.wordpress-staging-publisher"
mkdir -p "$local_user_home_dir/.wordpress-staging-publisher/$timestamp"
mkdir -p "$staging_dir"
mkdir -p "$production_dir"
mkdir -p "$console_dir"
mkdir -p "$console_dir/wordpress"

# Prepare the working area inside the staging
echo "STEP 1: Preparing..."
ssh -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name" 'bash -s' < "$script_dir/prepared/remote/front_liner.staging.sh" "$timestamp"
echo "STEP 1: Done."
echo

# Upload required scripts
echo "STEP 2: Loading the required scripts..."
scp -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$script_dir/baked/dump_helper.php" "$wp_staging_user_name@$wp_staging_machine_name:.wordpress-staging-publisher/$timestamp/staging/dump_helper.php"
echo "STEP 2: Done."
echo

# Generate the two zip files inside the remote staging machine
echo "STEP 3: Generating the WordPress zip file..."
ssh -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name" 'bash -s' < "$script_dir/prepared/remote/file_generator.zip.sh" "$timestamp" "$wp_staging_dir"
echo "STEP 3: Done."
echo

# Download the script for MySQL dump
echo "STEP 4: Downloading the MySQL dump script..."
scp -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name:.wordpress-staging-publisher/$timestamp/staging/dump.sh" "$console_dir/dump.sh"
chmod u+x "$console_dir/dump.sh"
echo "STEP 4: Done."
echo

# Backup the MySQL database of the staging, then delete the server's copy of the script
echo "STEP 5: Generating the database dump file..."
ssh -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name" 'bash -s' < "$console_dir/dump.sh"
echo "STEP 5: Done."
echo

# Download the WordPress zip file
echo "STEP 6: Downloading the WordPress zip file..."
scp -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name:.wordpress-staging-publisher/$timestamp/staging/wordpress.zip" "$console_dir/wordpress.staging.zip"
echo "STEP 6: Done."
echo

# Download the database sql file
echo "STEP 7: Downloading the database dump file..."
scp -i "$script_dir/config/staging/$wp_staging_user_name.pem" "$wp_staging_user_name@$wp_staging_machine_name:.wordpress-staging-publisher/$timestamp/staging/database.sql" "$console_dir/database.staging.sql"
echo "STEP 7: Done."
echo

# Search and replace database
echo "STEP 8: Search-and-replacing the database dump file..."
sed "s#$search#$replace#g" "$console_dir/database.staging.sql" > "$console_dir/database.production.sql"
echo "STEP 8: Done."
echo

# Unzip wordpress staging
echo "STEP 9: Unzipping the downloaded wordpress zip..."
unzip "$console_dir/wordpress.staging.zip" -d "$console_dir/wordpress" > /dev/null
echo "STEP 9: Done."
echo

# Copy the production my.cnf from the config file
cp "$script_dir/config/production/my.cnf" "$console_dir/my.production.cnf"

db_production_host=$(cat "$console_dir/my.production.cnf" | grep "host=" | tr "=" " " | awk '{print $2}' | tr -d "'" | tr -d '"' | xargs)
db_production_user=$(cat "$console_dir/my.production.cnf" | grep "user=" | tr "=" " " | awk '{print $2}' | tr -d "'" | tr -d '"' | xargs)
db_production_password=$(cat "$console_dir/my.production.cnf" | grep "password=" | tr "=" " " | awk '{print $2}' | tr -d "'" | tr -d '"' | xargs)
db_production_database=$(cat "$console_dir/my.production.cnf" | grep "database=" | tr "=" " " | awk '{print $2}' | tr -d "'" | tr -d '"' | xargs)

# Search and replace the wp-config.php file
echo "STEP 10: Preparing the wp-config.php file..."
php "$script_dir/prepared/local/wp-config.search-and-replace.php" "$db_production_host" "$db_production_user" "$db_production_password" "$db_production_database" "$console_dir/wordpress/wp-config.php"
echo "STEP 10: Done."
echo

# Zip the production wordpress
echo "STEP 11: Zipping the modified wordpress zip..."
cd "$console_dir/wordpress/"
zip -r "$console_dir/wordpress.production.zip" ./* > /dev/null
cd "$script_dir"
echo "STEP 11: Done."
echo

# Prepare the working area inside the production
echo "STEP 12: Uploading files to production..."
ssh -i "$script_dir/config/production/$wp_production_user_name.pem" "$wp_production_user_name@$wp_production_machine_name" 'bash -s' < "$script_dir/prepared/remote/front_liner.production.sh" "$timestamp"
echo "STEP 12: Done."
echo

# Uploading the wordpress zip file to production
echo "STEP 13: Uploading the wordpress zip file to production..."
scp -i "$script_dir/config/production/$wp_production_user_name.pem" "$console_dir/wordpress.production.zip" "$wp_production_user_name@$wp_production_machine_name:.wordpress-staging-publisher/$timestamp/production/wordpress.zip"
echo "STEP 13: Done."
echo

# Uploading the database file to production
echo "STEP 14: Uploading the wordpress database file to production..."
scp -i "$script_dir/config/production/$wp_production_user_name.pem" "$console_dir/database.production.sql" "$wp_production_user_name@$wp_production_machine_name:.wordpress-staging-publisher/$timestamp/production/database.sql"
echo "STEP 14: Done."
echo

# Uploading the database config file to production
echo "STEP 15: Uploading the database configuration file to production..."
scp -i "$script_dir/config/production/$wp_production_user_name.pem" "$console_dir/my.production.cnf" "$wp_production_user_name@$wp_production_machine_name:.my.cnf"
echo "STEP 15: Done."
echo

# Unzip the wordpress file inside the remote production machine
echo "STEP 16: Unzipping the WordPress zip file..."
ssh -i "$script_dir/config/production/$wp_production_user_name.pem" "$wp_production_user_name@$wp_production_machine_name" 'bash -s' < "$script_dir/prepared/remote/file_generator.unzip.sh" "$timestamp" "$wp_production_dir"
echo "STEP 16: Done."
echo

echo "DROP DATABASE IF EXISTS $db_production_database;" > "$console_dir/preparatory.sql"
echo "CREATE DATABASE IF NOT EXISTS $db_production_database;" >> "$console_dir/preparatory.sql"

# Upload the preparatory sql file
echo "STEP 17: Unzipping the WordPress zip file..."
scp -i "$script_dir/config/production/$wp_production_user_name.pem" "$console_dir/preparatory.sql" "$wp_production_user_name@$wp_production_machine_name:.wordpress-staging-publisher/$timestamp/console/preparatory.sql"
echo "STEP 17: Done."
echo

# Unzip the wordpress file inside the remote production machine
echo "STEP 18: Generate the database..."
ssh -i "$script_dir/config/production/$wp_production_user_name.pem" "$wp_production_user_name@$wp_production_machine_name" 'bash -s' < "$script_dir/prepared/remote/database_generator.sh" "$timestamp" "$wp_production_dir"
echo "STEP 18: Done."
echo
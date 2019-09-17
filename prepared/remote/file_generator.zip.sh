#!/bin/bash
# This script generates the wordpress.zip file while preparing the mysql dump.sh script.
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

timestamp="$1"
wp_staging_dir="$2"
staging_user_home_dir=$(eval echo "~")

# Go to the parent directory of the wordpress installation
cd "$wp_staging_dir"

just_basename=$(basename "$wp_staging_dir")

# Zip the contents of wordpress
zip -r "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/wordpress.zip" . > /dev/null

# Store the MySQL access credentials to text files
db_name=$(cat "$wp_staging_dir/wp-config.php" | grep "DB_NAME" | tr "," " " | awk '{print $2}' | tr -d "'" | tr -d '"' | tr -d ")" | tr -d ";" | xargs)
db_user=$(cat "$wp_staging_dir/wp-config.php" | grep "DB_USER" | tr "," " " | awk '{print $2}' | tr -d "'" | tr -d '"' | tr -d ")" | tr -d ";" | xargs)
db_password=$(cat "$wp_staging_dir/wp-config.php" | grep "DB_PASSWORD" | tr "," " " | awk '{print $2}' | tr -d "'" | tr -d '"' | tr -d ")" | tr -d ";" | xargs)
db_host=$(cat "$wp_staging_dir/wp-config.php" | grep "DB_HOST" | tr "," " " | awk '{print $2}' | tr -d "'" | tr -d '"' | tr -d ")" | tr -d ";" | xargs)
echo "$db_name" > "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/db_name"
#echo "$db_user" > "$staging_user_home_dir/.wordpress.$timestamp/db_user"
#echo "$db_password" > "$staging_user_home_dir/.wordpress.$timestamp/db_password"
#echo "$db_host" > "$staging_user_home_dir/.wordpress.$timestamp/db_host"

# Generate the personal my.cnf file inside the user's home directory
echo "[client]" > "$staging_user_home_dir/.my.cnf"
echo "host="$db_host"" >> "$staging_user_home_dir/.my.cnf"
echo "user="$db_user"" >> "$staging_user_home_dir/.my.cnf"
echo "password="$db_password"" >> "$staging_user_home_dir/.my.cnf"
echo "database="$db_name"" >> "$staging_user_home_dir/.my.cnf"

# Generate the script for MySQL dump
echo "#!/bin/bash" > "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump.sh"
php "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump_helper.php" "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging" >> "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump.sh"
echo "rm $staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump.sh" >> "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump.sh"

# Remove the temporary variables
rm "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/db_name"

# Remove the PHP utility tool
rm "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging/dump_helper.php"
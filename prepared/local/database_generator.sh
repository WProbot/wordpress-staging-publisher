#!/bin/bash
# This script overrides the current database with the updated the database.
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

local_user_home_dir=$(eval echo "~")
local_working_dir="$local_user_home_dir/.wordpress-staging-publisher/$timestamp"
production_dir="$local_working_dir/production"
console_dir="$local_working_dir/console"

mysql < "$console_dir/preparatory.sql"
mysql < "$production_dir/database.sql"
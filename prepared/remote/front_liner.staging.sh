#!/bin/bash
# This script prepares the working directories of the staging environment intended to be used with SSH.
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
staging_user_home_dir=$(eval echo "~")

# Create a workspace inside the user's home directory
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher"
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp"
mkdir -p "$staging_user_home_dir/.wordpress-staging-publisher/$timestamp/staging"
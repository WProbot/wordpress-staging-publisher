#!/bin/bash
# This script archives the existing wordpress installation, then overrides the current directory.
# with the the updated package.
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

# Archive the existing wordpress installation
cd "$wp_production_dir/"
zip -o -r "$console_dir/wordpress.archive.$timestamp.zip" ./* > /dev/null

# Remove the contents of the directory before putting the contents
# Uncomment the below statement for this to function
# rm -r $wp_production_dir/*

# Put the contents to the wordpress directory for production
unzip -o "$production_dir/wordpress.zip" -d "$wp_production_dir" > /dev/null
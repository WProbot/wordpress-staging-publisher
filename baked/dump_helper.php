<?php
/**
This script helps build the mysql dump.sh script.
Copyright (C) 2019  Abel Callejo, International Rice Research Institute (a.callejo@irri.org)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses/gpl-3.0.html.
**/

$db_name = trim(file_get_contents($argv[1]."/db_name"));
echo "mysqldump " . $db_name ." --result-file=" . $argv[1] . "/database.sql" . PHP_EOL;
?>
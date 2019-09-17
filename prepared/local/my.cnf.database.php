<?php
/**
This script helps build the mysql database overrider script.
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

if( isset($argv[1]) && isset($argv[2]) ){
	$file = file($argv[1]);
	$timestamp = $argv[2];

	if( count($file)>0 ) {
		for($i=0; $i<count($file); $i++) {

			/** Database **/
			if( stripos($file[$i],"database")!==false ){
				$parts = explode("=",$file[$i]);
				if( isset($parts[1]) && !empty(trim($parts[1])) ){
					echo "mysql " . $parts[1] . " < ;
				}
			}

		}
	}

}
?>
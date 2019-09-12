<?php
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
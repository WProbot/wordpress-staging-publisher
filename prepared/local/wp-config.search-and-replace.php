<?php
if( isset($argv[1]) && isset($argv[2]) && isset($argv[3]) && isset($argv[4]) && isset($argv[5]) ){
	$db_host = $argv[1];
	$db_user = $argv[2];
	$db_password = $argv[3];
	$db_name = $argv[4];

	$file = file($argv[5]);

	if( count($file)>0 ) {
		for($i=0; $i<count($file); $i++) {

			/** Host **/
			if( stripos($file[$i],"define")!==false && strpos($file[$i],"DB_HOST")!==false ){
				eval( $file[$i] );
				if( !empty(DB_HOST) ){
					$file[$i] = str_replace( DB_HOST, $db_host, $file[$i] );
				}
			}

			/** User **/
			if( stripos($file[$i],"define")!==false && strpos($file[$i],"DB_USER")!==false ){
				eval( $file[$i] );
				if( !empty(DB_USER) ){
					$file[$i] = str_replace( DB_USER, $db_user, $file[$i] );
				}
			}

			/** Password **/
			if( stripos($file[$i],"define")!==false && strpos($file[$i],"DB_PASSWORD")!==false ){
				eval( $file[$i] );
				if( !empty(DB_PASSWORD) ){
					$file[$i] = str_replace( DB_PASSWORD, $db_password, $file[$i] );
				}
			}

			/** Database name **/
			if( stripos($file[$i],"define")!==false && strpos($file[$i],"DB_NAME")!==false ){
				eval( $file[$i] );
				if( !empty(DB_NAME) ){
					$file[$i] = str_replace( DB_NAME, $db_name, $file[$i] );
				}
			}

		}
		file_put_contents($argv[5], $file);
	}
}
?>
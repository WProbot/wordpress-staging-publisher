<?php
$db_name = trim(file_get_contents($argv[1]."/db_name"));
echo "mysqldump " . $db_name ." --result-file=" . $argv[1] . "/database.sql" . PHP_EOL;
?>
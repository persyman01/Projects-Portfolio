<?php

$servername="localhost";
$username="persy"
$password="persy"


try {
	$connect = new PDO("mysql:host=$servername;dbname=st_francis", $username, $password);

    $connect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo " Connected Successfully ";
}
catch(PDOException $e)

{
	echo " Connection failed" . $e->getMessage();
}
 $connect = null;
?>
<?php
require_once("dbCredentials.php");  // created variables to login
require_once("dbConnect.php");

if (!isset($_POST['club']))  {
	header('Location: index.html');
	exit;
}

$con = open_connection($servername, $username, $password, $database);

echo $_POST['club'];
?>
<?php
if (!isset($_POST['club']))  {
	header('Location: index.html');
	exit;
}

require_once("dbConnect.php");
if (!isset($conn))  {
	header('Location: index.html');
	exit;
}

echo $_POST['club'];
?>
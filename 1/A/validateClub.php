<?php

if (!isset($_POST['club']))  {
	header('Location: index.html');
	exit;
}

echo $_POST['club'];

?>
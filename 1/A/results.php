﻿<?php
require_once("dbCredentials.php");  // created variables to login
require_once("dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$sql = "SELECT *, CONCAT(
	(CASE WHEN
		(club_votes * 100 / (SELECT SUM(`club_votes`) FROM football_clubs)) IS NULL
	 THEN
		0 
	 ELSE
		club_votes * 100 / (SELECT SUM(`club_votes`) FROM football_clubs) 
	 END), '%') as percent,
	(SELECT SUM(`club_votes`) FROM football_clubs) as fans FROM football_clubs";
$result = mysqli_query($con, $sql);
if (!$result)  {
	die("An Error occurred while getting the Football Teams. Error: '" . mysqli_error($con)) . "'";
}

$output = "";
while ($row = mysqli_fetch_assoc($result))  {
	$name = $row['club_name'];
	$votes = $row['club_votes'];
	$percent = $row['percent'];
	$fans = $row['fans'];
	$output .= "\t\t$name | $votes | $percent<br />\n";
}
$output .= "\t\tTotal | $fans | 100%<br />\n";

mysqli_free_result($result);
mysqli_close($con);
?>

<html>
	<head>
		<title>Auswertung der Statistik | Fussballfans</title>
		<meta charset="UTF-8" />
	</head>
	<body>
<?php
		echo $output;
?>
	</body>
</html>
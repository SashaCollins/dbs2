<?php
header('Content-Type: text/html; charset=utf-8');
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

include("graph.php");
$removeNull = true;

$con = open_connection($servername, $username, $password, $database);

$sql = "SELECT *, CONCAT(
	(CASE WHEN
		(SELECT SUM(`club_votes`) FROM football_clubs) = 0
	 THEN
		0 
	 ELSE
		club_votes * 100 / (SELECT SUM(`club_votes`) FROM football_clubs) 
	 END), '%') as percent,
	(SELECT SUM(`club_votes`) FROM football_clubs) as fans FROM football_clubs;";
$result = mysqli_query($con, $sql);
if (!$result)  {
	die("An Error occurred while getting the Football Teams. Error: '" . mysqli_error($con) . "'");
}

$output = "";
$data = array();    // Votes
$legend = array();  // Names
while ($row = mysqli_fetch_assoc($result))  {
	$name = $row['club_name'];
	$votes = $row['club_votes'];
	$percent = $row['percent'];
	$fans = $row['fans'];
	$output .= "\t\t\t<tr><td class='name'>$name</td><td>$votes</td><td>$percent</td></tr>\n";
	
	if ($votes != 0 || !$removeNull)  {
		array_push($data, $votes);
		array_push($legend, $name);
	}
}
$output .= "\t\t\t<tr class='footer'><th style='text-align: right;'>Total:</th><td>$fans</td><td>100%</td></tr>\n";

$filename = "fan-statistic.png";
if ($fans != 0)  {
	draw_graph($data, $legend, $filename);
}

mysqli_free_result($result);
mysqli_close($con);
?>

<html>
	<head>
		<title>Auswertung der Statistik | Fussballfans</title>
		<meta charset="UTF-8" />
		<style>
			td  {
				text-align: right;
			}
			td.name  {
				text-align: center;
			}
			tr.header  {
				border-bottom: 2px solid;
			}
			tr.footer  {
				border-top: 2px solid;
			}
			td, th  {
				padding-left: 5px;
				padding-right: 5px;
			}
			table  {
				border-collapse: collapse;
			}
			tr  {
				border: 1px solid;
			}
			table td, table th  {
				border-left: 2px solid;
			}
			table td:first-child, table th:first-child  {
				border-left: none;
			}
		</style>
	</head>
	<body>
		<center>
		<table style="border-style: solid; border-width: 3px;">
			<tr class="header"><th>Vereinsname</th><th>Anzahl Stimmen</th><th>Prozentualer Anteil</th></tr>
<?php
			echo $output;
?>
		</table>
<?php
		if ($fans != 0)  {
			echo "\t\t".'<br /><img src="'.$filename.'" />';
		}
?>

		</center>
	</body>
</html>
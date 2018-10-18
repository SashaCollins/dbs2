<?php

require_once("dbCredentials.php");  // created variables to login
require_once("dbConnect.php");

if (!isset($_POST['club']))  {
	header('Location: ./');
	exit;
}

$con = open_connection($servername, $username, $password, $database);

$club_id = $_POST['club'];
$sql = "UPDATE football_clubs SET club_votes = club_votes + 1 WHERE club_id = $club_id";

if (!mysqli_query($con, $sql)) {
	die("An Error occurred while updating the Football Table. Error: '" . mysqli_error($con)) . "'";
}

$sql = "SELECT club_name, club_votes, SUM(club_votes) as fans FROM football_clubs WHERE club_id = $club_id";

$sql_result = mysqli_query($con, $sql);
if (!$sql_result) {
	die("An Error occurred while evaluating the response. Error: '" . mysqli_error($con)) . "'";
}

$row = mysqli_fetch_assoc($sql_result);
$club_name = $row['club_name'];
$vote = $row['club_votes'];
$fans = $row['fans'];

echo "Du hast erfolgreich für $club_name gestimmt.<br>
		$club_name hat $vote Fans. :D <br>
		Insgesamt haben $fans Fans abgestimmt.<br>";
?>
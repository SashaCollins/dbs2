<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

// Return Error to previous Page
if (!function_exists('returnError'))  {
	function returnError($err)  {
		die(header('Location: ./?error='.$err));
	}
}

if (isset($_COOKIE['club_vote'])) {
	returnError("Du hast bereits an der Umfrage teilgenommen!");
}

if (!isset($_POST['club']))  {
	header('Location: ./');
	exit;
}

$con = open_connection($servername, $username, $password, $database);
$table = "football_clubs";

$check = $_POST['check'];
$club_id = $_POST['club'];
$other = ($club_id == "other"? true : false);

// Lock Database
mysqli_autocommit($con, false);
//mysqli_begin_transaction($con);

// Deactivated JavaScript would lead that $check won't be changed on submit
// Check if valid
if (preg_match("/^[0-9]+$/", $club_id) && empty($check)) {
	$sql = "SELECT 1 FROM $table WHERE club_id = ?";
	$stmt = mysqli_prepare($con, $sql);
	mysqli_stmt_bind_param($stmt, 'i', $club_id);

}  else  {
	$sql = "SELECT 1 FROM $table WHERE club_id = ? AND club_name = ?";
	$stmt = mysqli_prepare($con, $sql);
	mysqli_stmt_bind_param($stmt, 'is', $club_id, $check);
}

mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);
$results = mysqli_stmt_num_rows($stmt);
mysqli_stmt_close($stmt);

if ($other && empty($_POST['newClub']))  {
	returnError("Bitte gib deinen neuen Verein ein!");
}

// No Match
if ($results == 0 && !$other)  {
	returnError("Not Valid Input!");
}

// New suggestion
if ($other)  {
	$suggestion = $_POST['newClub'];
	
	// Already exists?
	$sql = "SELECT 1 FROM $table WHERE club_name = ?;";
	$stmt = mysqli_prepare($con, $sql);
	mysqli_stmt_bind_param($stmt, 's', $suggestion);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_store_result($stmt);
	$results = mysqli_stmt_num_rows($stmt);
	mysqli_stmt_close($stmt);
	
	if ($results != 0)  {
		returnError("Diesen Verein gibt es bereits, bitte in der Liste auswählen!");
	}
	
	// Insert
	$sql = "INSERT INTO `$table` (`club_name`, `club_votes`) VALUES (?, 1)";
	$stmt = mysqli_prepare($con, $sql);
	mysqli_stmt_bind_param($stmt, 's', $suggestion);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_store_result($stmt);
	$insert_id = mysqli_stmt_insert_id($stmt);
	mysqli_stmt_close($stmt);
	
	if ($insert_id == 0)  {
		returnError("Unknown Error while Inserting Custom Club '$suggestion'!");
	}
	
	// Set output values
	$club_name = $suggestion;
	$club_votes = 1;
	
	$sql = "SELECT SUM(`club_votes`) as fans FROM $table;";
	$sql_result = mysqli_query($con, $sql);
	if (!$sql_result) {
		returnError("An Error occurred while getting the total amount of fans. Error: '" . mysqli_error($con) . "'");
	}
	$row = mysqli_fetch_assoc($sql_result);
	$fans = $row['fans'];
	
}  else  {
	
	$sql = "UPDATE $table SET club_votes = club_votes + 1 WHERE club_id = ?;";
	$stmt = mysqli_prepare($con, $sql);
	if (!$stmt) {
		returnError("An Error occurred while updating the Football Table. Error: '" . mysqli_error($con) . "'");
	}

	mysqli_stmt_bind_param($stmt, 'i', $club_id);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_close($stmt);

	$sql = "SELECT *, (SELECT SUM(`club_votes`) FROM $table) as fans FROM $table WHERE `club_id` = ?;";
	$stmt = mysqli_prepare($con, $sql);
	if (!$stmt) {
		returnError("An Error occurred while evaluating the response. Error: '" . mysqli_error($con) . "'");
	}
	mysqli_stmt_bind_param($stmt, "i", $club_id);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_bind_result($stmt, $club_id, $club_name, $club_votes, $fans);
	mysqli_stmt_fetch($stmt);
	mysqli_stmt_close($stmt);
}

// Commit
mysqli_commit($con);

// Unlock Database
mysqli_close($con);

setcookie("club_vote", "Done", time()+60*60*24*(3*365 + 366));

$out = "<center>Du hast erfolgreich für <b>$club_name</b> gestimmt!<br>
<b>$club_name</b> hat bereits <b>$club_votes Fans</b>. :D <br>
Insgesamt haben bereits $fans Personen abgestimmt.<br /><br />
<a href='results.php'>Hier</a> kannst du sehen, wie bislang abgestimmt wurde.</center>";

?>

<html>
	<head>
		<meta charset="UTF-8">
		<title>Erfolgreich abgestimmt!</title>
	</head>
	<body>
		<?php echo $out; ?>
	</body>
</html>
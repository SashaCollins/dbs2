<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

// TODO Set Cookie on Success and check it to avoid multiple votes

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

// Check if valid
$sql = "SELECT 1 FROM $table WHERE club_id = ? AND club_name = ?";
$stmt = mysqli_prepare($con, $sql);
mysqli_stmt_bind_param($stmt, 'is', $club_id, $check);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);
$results = mysqli_stmt_num_rows($stmt);
mysqli_stmt_close($stmt);

// No Match
if($results == 0 && !$other)  {
	die("Not Valid Input!");
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
		die("This football club already exists, please choose it from the List!");
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
		die("Unknown Error while Inserting Custom Club '$suggestion'!");
	}
	
	// Set output values
	$club_name = $suggestion;
	$club_votes = 1;
	
	$sql = "SELECT SUM(`club_votes`) as fans FROM $table;";
	$sql_result = mysqli_query($con, $sql);
	if (!$sql_result) {
		die("An Error occurred while getting the total amount of fans. Error: '" . mysqli_error($con) . "'");
	}
	$row = mysqli_fetch_assoc($sql_result);
	$fans = $row['fans'] + 1;
	
}  else  {
	
	$sql = "UPDATE $table SET club_votes = club_votes + 1 WHERE club_id = ? AND club_name = ?;";
	$stmt = mysqli_prepare($con, $sql);
	if (!$stmt) {
		die("An Error occurred while updating the Football Table. Error: '" . mysqli_error($con) . "'");
	}

	mysqli_stmt_bind_param($stmt, 'is', $club_id, $check);
	mysqli_stmt_execute($stmt);
	mysqli_stmt_close($stmt);

	$sql = "SELECT *, (SELECT SUM(`club_votes`) FROM $table) as fans FROM $table WHERE `club_id` = ?;";
	$stmt = mysqli_prepare($con, $sql);
	if (!$stmt) {
		die("An Error occurred while evaluating the response. Error: '" . mysqli_error($con) . "'");
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

$out = "<center>Du hast erfolgreich für <b>$club_name</b> gestimmt!<br>
<b>$club_name</b> hat bereits <b>$club_votes Fans</b>. :D <br>
Insgesamt haben bereits $fans Personen abgestimmt.<br /><br />
<a href='results.php'>Hier</a> kannst du sehen, wie bislang abgestimmt wurde.</center>";

// TODO Don't call "die", return properly so that also proper HTML will be generated
?>

<html>
	<head>
		<meta charset="UTF-8">
		<title><?php echo (empty($out)) ? "Fehler ist aufgetreten!" : "Erfolgreich abgestimmt!" ?></title>
	</head>
	<body>
		<?php echo $out; ?>
	</body>
</html>
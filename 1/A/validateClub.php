<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

if (!isset($_POST['club']))  {
	header('Location: ./');
	exit;
}

$con = open_connection($servername, $username, $password, $database);

$club_id = $_POST['club'];  // TODO if $club_id == 'other' || id not in Table (HTML Injection)

// Lock Database
mysqli_autocommit($con, false);
//mysqli_begin_transaction($con);

$sql = "UPDATE football_clubs SET club_votes = club_votes + 1 WHERE club_id = ?;";
$stmt = mysqli_prepare($con, $sql);
if (!$stmt) {
	die("An Error occurred while updating the Football Table. Error: '" . mysqli_error($con)) . "'";
}

mysqli_stmt_bind_param($stmt, 'i', $club_id);
mysqli_stmt_execute($stmt);
mysqli_stmt_close($stmt);

$sql = "SELECT *, (SELECT SUM(`club_votes`) FROM football_clubs) as fans FROM football_clubs WHERE `club_id` = ?;";
$stmt = mysqli_prepare($con, $sql);
if (!$stmt) {
	die("An Error occurred while evaluating the response. Error: '" . mysqli_error($con)) . "'";
}
mysqli_stmt_bind_param($stmt, "i", $club_id);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt, $club_id, $club_name, $club_votes, $fans);
mysqli_stmt_fetch($stmt);
mysqli_stmt_close($stmt);

// Commit
mysqli_commit($con);

// Unlock Database
mysqli_close($con);

$out = "<center>Du hast erfolgreich für <b>$club_name</b> gestimmt!<br>
<b>$club_name</b> hat bereits <b>$club_votes Fans</b>. :D <br>
Insgesamt haben bereits $fans Personen abgestimmt.<br /><br />
<a href='results.php'>Hier</a> kannst du sehen, wie bislang abgestimmt wurde.</center>";
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
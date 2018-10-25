<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$result = mysqli_query($con, "SELECT mailinglist_id, mailinglist_name FROM mailinglists");
if (!$result)  {
	die("An Error occurred while getting the Mailinglists. Error: '" . mysqli_error($con) . "'");
}

$output = "";
while ($row = mysqli_fetch_assoc($result))  {
	$id = $row['mailinglist_id'];
	$name = $row['mailinglist_name'];
	$output .= "\t\t\t\t\t<input type='checkbox' name='mailing' id='$id' value='$id'><label for='$id'>$name</label><br />";
}

mysqli_free_result($result);

$name = $_POST['name'];
$mail = $_POST['mail'];
$member = $_POST['member'];

$input = mysqli_prepare($con, "SELECT 1 FROM newsletter WHERE email = ?;");
if (!$input) {
	die("An error occurred while inserting into the newsletter table. Error: '" . mysqli_error($con) . "'");
}
mysqli_stmt_bind_param($input, 's', $mail);
mysqli_stmt_execute($input);
mysqli_stmt_store_result($input);
$results = mysqli_stmt_num_rows($input);
mysqli_stmt_close($input);

// Not in Table yet
if($results == 0)  {
	$input = mysqli_prepare($con, "INSERT INTO `newsletter` (`person_name`, `email`, `club_member`) VALUES (?, ?, ?)");
	if (!$input) {
		die("An error occurred while inserting into the newsletter table. Error: '" . mysqli_error($con) . "'");
	}
	mysqli_stmt_bind_param($input, 'sss', $name, $mail, $member);
	mysqli_stmt_execute($input);
	mysqli_stmt_close($input);
}

mysqli_close($con);
?>

<html>
<head>
	<meta charset="UTF-8">
	<title>Vereinsmailer | DFB</title>
	<style>
		th  {
			text-align: right;
			padding-right: 5px;
		}
		span#required  {
			color: #ff0000;
		}
	</style>
</head>
<body>
	<h1>Mitglied des Newsletters werden!</h1>
	<form method="POST">
		<table>
			<tr>
				<th>Name:<span id="required">*</span></th>
				<td><input name="name" maxlength=64 placeholder="Martin Fischer" /></td>
			</tr>
			<tr>
				<th>E-Mail-Adresse:<span id="required">*</span></th>
				<td><input name="mail" maxlength=64 placeholder="martin.fischer@hm.edu" /></td>
			</tr>
			<tr>
				<th>Mitglied in einem Verein?<span id="required">*</span></th>
				<td>
					<input type="radio" id="yes" name="member" value="true">
					<label for="yes">Ja</label> 
					<input type="radio" id="no" name="member" value="false">
					<label for="no"> Nein</label><br />
				</td>
			</tr>
			<tr>
				<th>Mailing-Listen:</th>
				<td>
<?php
					echo $output;
?>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><br /><input type="submit" value="Abonnieren!" /></td>
			</tr>
		</table>
	</form>
</body>
</html>
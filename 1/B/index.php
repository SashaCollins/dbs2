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
	$output .= "\t\t\t\t\t<input type='checkbox' name='mailing[]' value='$id' ".(isset($_POST['mailing']) && in_array($id, $_POST['mailing']) ? 'checked' : '')."><label for='$id'>$name</label><br />\n";
}

mysqli_free_result($result);

$success = false;
if (isset($_POST['submit'])) {
	$errors = [];
	
	$name = $_POST['name'];
	if (empty($name)) {
		$errors[] = "Bitte gib deinen Namen ein";
	}
	
	$mail = $_POST['mail'];
	if (empty($mail)) {
		$errors[] = "Bitte gib deine Email-Adresse ein";
	}
	elseif (!filter_var($mail, FILTER_VALIDATE_EMAIL)) {
		$errors[] = "Deine Email-Adresse ist invalide";
	}
	
	if (isset($_POST['member'])){
		$member = $_POST['member'];
	} 
	else {
		$errors[] = "Bitte gib an ob du in einem Verein bist";
	}
	
	if(empty($errors)){
		$input = mysqli_prepare($con, "SELECT 1 FROM newsletter_members WHERE person_mail = ?;");
		if (!$input) {
			die("An error occurred while inserting into the newsletter_members table. Error: '" . mysqli_error($con) . "'");
		}
		mysqli_stmt_bind_param($input, 's', $mail);
		mysqli_stmt_execute($input);
		mysqli_stmt_store_result($input);
		$results = mysqli_stmt_num_rows($input);
		mysqli_stmt_close($input);

		// Not in Table yet
		if($results == 0)  {
			$input = mysqli_prepare($con, "INSERT INTO `newsletter_members` (`person_name`, `person_mail`, `club_member`) VALUES (?, ?, ?)");
			if (!$input) {
				die("An error occurred while inserting into the newsletter_members table. Error: '" . mysqli_error($con) . "'");
			}
			mysqli_stmt_bind_param($input, 'sss', $name, $mail, $member);
			mysqli_stmt_execute($input);
			mysqli_stmt_store_result($input);
			$personId = mysqli_stmt_insert_id($input);
			mysqli_stmt_close($input);
			
			if($personId == 0){
				die("An error occurred while inserting into the newsletter_members table. Error: '" . mysqli_error($con) . "'");
			}
			if (isset($_POST['mailing'])) {
				$listIDs = $_POST['mailing'];
				foreach($listIDs as $listId){
					$input = mysqli_prepare($con, "INSERT INTO `newsletter_mailing_mapping` (`person_id`, `mailinglist_id`) VALUES (?, ?)");
					if (!$input) {
						die("An error occurred while inserting into the mapping table. Error: '" . mysqli_error($con) . "'");
					}
					mysqli_stmt_bind_param($input, 'ii', $personId, $listId);
					mysqli_stmt_execute($input);
					mysqli_stmt_close($input);
				}
			}
			$success = true;
			//die("Du hast dich erfolgreich registriert!");
		}  
		else  {
			$errors[] = "Diese Email-Adresse ist bereits registriert";
		}
	}
}
mysqli_close($con);

?>

<html>
<head>
	<meta charset="UTF-8">
	<title>Newsletter | DFB</title>
	<style>
		th  {
			text-align: right;
			padding-right: 5px;
		}
		span#required, div#error  {
			color: #ff0000;
		}
	</style>
</head>
<body>
	<h1>Mitglied des Newsletters werden!</h1>
<?php
		if(isset($errors)){
			echo "<div id='error'><ul>";
			foreach($errors as $err){
				echo "<li>".$err ."</li>";
			}
			echo "</ul></div>";
		}
?>

<?php
if (!$success)  {
?>
	<form method="POST">
		<table>
			<tr>
				<th>Name:<span id="required">*</span></th>
				<td><input name="name" maxlength=64 placeholder="Martin Fischer" value="<?php echo(isset($_POST['name']) ? $_POST['name'] : ""); ?>"/></td>
			</tr>
			<tr>
				<th>E-Mail-Adresse:<span id="required">*</span></th>
				<td><input name="mail" maxlength=64 placeholder="martin.fischer@hm.edu" value="<?php echo(isset($_POST['mail']) ? $_POST['mail'] : ""); ?>"/></td>
			</tr>
			<tr>
				<th>Mitglied in einem Verein?<span id="required">*</span></th>
				<td>
					<input type="radio" id="yes" name="member" value="true" <?php echo(isset($_POST['member']) && $_POST['member'] == 'true' ? 'checked' : ''); ?>>
					<label for="yes">Ja</label> 
					<input type="radio" id="no" name="member" value="false" <?php echo(isset($_POST['member']) && $_POST['member'] == 'false' ? 'checked' : ''); ?>>
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
				<td><br /><input name="submit" type="submit" value="Abonnieren!" /></td>
			</tr>
		</table>
	</form>
<?php }
else{
	echo "<h4>Du hast dich erfolgreich registriert!</h4>";
}
?>
</body>
</html>
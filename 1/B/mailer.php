<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$result = mysqli_query($con, "SELECT mailinglist_id, mailinglist_name FROM mailinglists");
if (!$result)  {
	die("An Error occurred while getting the Mailinglists. Error: '" . mysqli_error($con) . "'");
}

$list = "";
while ($row = mysqli_fetch_assoc($result))  {
	$id = $row['mailinglist_id'];
	$name = $row['mailinglist_name'];
	$list .= "\t\t\t\t<input type='checkbox' name='mailing[]' id='$id' value='$id' ".(isset($_POST['mailing']) && in_array($id, $_POST['mailing']) ? 'checked' : '')."><label for='$id'>$name</label><br />\n";
}

$result = mysqli_query($con, "SELECT person_id, person_name, person_mail FROM newsletter_members");
if (!$result)  {
	die("An Error occurred while getting the newsletter_members. Error: '" . mysqli_error($con) . "'");
}

$people = "";
while ($row = mysqli_fetch_assoc($result))  {
	$id = $row['person_id'];
	$name = $row['person_name'];
	$mail = $row['person_mail'];
	$people .= "\t\t\t<option value='$id'>$name &lt;$mail&gt;</option>\n";
}

mysqli_free_result($result);
mysqli_close($con);
?>

<html>
<head>
	<meta charset="UTF-8">
	<title>Vereinsmailer | DFB</title>
	<style>
		h1{
			text-align: center;
			font-size: 35px;
		}
		h3{
			font-size: 25px;
			margin-bottom: 0px;
		}
		th  {
			text-align: right;
			padding-right: 5px;
		}
		span#required, div#error  {
			color: #ff0000;
		}
		body, option, select, input, textarea {
			font-family: Arial;
			font-size: 15px;
		}
	</style>
</head>
<body>
	<div style="margin-left: 25%; margin-right: 25%;">
		<h1>Spammail verschicken hier!!</h1>
		<form method="POST">	
			<h3><label for="subject">Betreff:<span id="required">*</span></label></h3>
			<input id="subject" name="subject" style="width: 100%"></input>
					
			<h3><label for="body">Text:<span id="required">*</span></label></h3>				
			<textarea id="body" name="body" style="width: 100%; resize: vertical;" rows="10"></textarea>
			
			<div style="float: left">
				<h3>Wähle eine:<span id="required">*</span><br />Vordefinition:</h3>				
				<input type="radio" id="all" name="member" value="all" <?php echo(isset($_POST['member']) && $_POST['member'] == 'all' ? 'checked' : ''); ?>>
				<label for="all">An Alle</label><br />
				<input type="radio" id="members" name="member" value="members" <?php echo(isset($_POST['member']) && $_POST['member'] == 'members' ? 'checked' : ''); ?>>
				<label for="members">An Vereinsmitglieder</label><br />
				<input type="radio" id="nonMember" name="member" value="nonMembers" <?php echo(isset($_POST['member']) && $_POST['member'] == 'nonMembers' ? 'checked' : ''); ?>>
				<label for="nonMember">An Nicht-Vereinsmitglieder</label><br /><br />
				
				<h3>Mailinglist:</h3>
<?php
					echo $list;
?>				<br />
				
				<h3>Geschnitten oder Vereinigt?</h3>
				<input type="radio" id="intersection" name="both" value="intersection" <?php echo(isset($_POST['both']) && $_POST['both'] == 'intersection' ? 'checked' : ''); ?>>
				<label for="intersection">Mail an Vordefinition &cap; Mailinglist</label><br />
				<input type="radio" id="union" name="both" value="union" <?php echo(isset($_POST['both']) && $_POST['both'] == 'union' ? 'checked' : ''); ?>>
				<label for="union">Mail an Vordefinition &cup; Mailinglist</label><br />
			</div>
			<div style="text-align: right; float: right">
				<h3>...oder wähle die Empfänger selbst:<span id="required">*</span></h3>
				<select name="club" id="clubs" size="7" onchange="checkCustom()" multiple>
					<option value="select" selected>Bitte Auswählen:</option>
<?php
					echo $people;
?>
				</select>
			</div>
			<div style="clear: both; padding-top: 15px;">
				<center><input name="submit" type="submit" value="Mails verschicken" /></center>
			</div>
		</form>
	</div>
</body>
</html>
<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$success = false;
if (isset($_POST['submit'])) {
	$subject = $_POST['subject'];
	$body = $_POST['body'];
	$member = (isset($_POST['member']) ? $_POST['member'] : ''); // can be 'all', 'member' or 'nonMember' (or nothing if not set)
	$recipients = (isset($_POST['recipients']) ? $_POST['recipients'] : array());
	$mailing = (isset($_POST['mailing']) ? $_POST['mailing'] : '');  // mailinglist-id
	$both = (isset($_POST['both']) ? true : false);  // option
	
	$errors = [];
	
	if (empty($subject)) {
		$errors[] = "Bitte einen Betreff ein";
	}
	
	if (empty($body)) {
		$errors[] = "Bitte gib deinen Mail-Text an";
	}
	
	if (empty($member) && empty($mailing) && (in_array('select', $recipients) || empty($recipients))){
		$errors[] = "Bitte gib an, an wen du deine Mail senden willst";
	}
	
	if ((!empty($member) || !empty($mailing)) && !in_array('select', $recipients)) {
		$errors[] = "Du hast eine doppelte Auswahl getroffen!<br>
					Deine Vordefinition wurde zurückgesetzt.<br>
					Bitte wähle eine Vordefinition ODER wähle die Empfänger selbst!";
		unset($_POST['member']);
		unset($_POST['mailing']);
	}
	
	if (empty($errors)) {
		$sql = "SELECT p.person_name, p.person_mail 
		FROM `mailinglists` as l, `newsletter_members` as p
		LEFT JOIN `newsletter_mailing_mapping` m ON p.person_id = m.person_id
		WHERE (l.mailinglist_id = m.mailinglist_id OR m.mailinglist_id IS NULL) /* in case not in a mailing list */";
		if (in_array('select', $recipients)) {		
			if ($member != "all") {
				if (!empty($member)){
					$sql .= " AND";
					if (!empty($mailing)){
						$sql .= " (";
					}
					$sql .= " p.club_member = ".(($member == 'member') ? "'true'" : "'false'");
				}
				if (!empty($mailing)) {
					$sql .= " ".($both || empty($member) ? "AND" : "OR")." (l.mailinglist_id = $mailing AND m.mailinglist_id IS NOT NULL /* in case not in a mailing list */)";
					if($member != "all" && !empty($member)){
						$sql .= " )";
					}
				}
			}
		}
		else {
			for ($c = 0; $c < sizeof($recipients); $c++)  {
				$id = $recipients[$c];
				if ($c == 0)  {
					$sql .= " AND (p.person_id = $id";
				} else {
					$sql .= " OR p.person_id = $id";
				}
				if ($c == sizeof($recipients) - 1)  {  // not elseif, size(array) could be 1
					$sql .= ")";
				}
			}
		}
		$sql .= " GROUP BY p.person_id ORDER BY p.person_id;";
		echo $sql;
		
		$result = mysqli_query($con, $sql);
		if (!$result){
			die("An Error occurred while getting the Mailinglists. Error: '" . mysqli_error($con) . "'");
		}
		while ($row = mysqli_fetch_assoc($result))  {
			$name = $row['person_name'];
			$mail = $row['person_mail'];
			//TODO print mails
		}
		$success = true;
	}
}

if(!$success){	
	$result = mysqli_query($con, "SELECT mailinglist_id, mailinglist_name FROM mailinglists");
	if (!$result)  {
		die("An Error occurred while getting the Mailinglists. Error: '" . mysqli_error($con) . "'");
	}

	$list = "";
	while ($row = mysqli_fetch_assoc($result))  {
		$id = $row['mailinglist_id'];
		$name = $row['mailinglist_name'];
		$list .= "\t\t\t\t<input type='radio' name='mailing' id='$id' value='$id' ".(isset($_POST['mailing']) && $_POST['mailing'] == $id ? 'checked' : '')."><label for='$id'>$name</label><br />\n";
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
		$people .= "\t\t\t<option value='$id' ".(isset($_POST['recipients']) && in_array($id, $_POST['recipients']) ? 'selected' : '').">$name &lt;$mail&gt;</option>\n";
	}

	mysqli_free_result($result);
	mysqli_close($con);
}
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
			margin-bottom: 10px;
		}
		h5{
			margin-top: 0px;
		}
		select{
			margin-top: 10px;
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
<?php
if (!$success)  {  // Cheap Trick
?>
	<div style="margin-left: 25%; margin-right: 25%;">
		<h1>Spammail verschicken hier!!</h1>
<?php
		if (isset($errors)){
			echo "<div id='error'><ul>";
			foreach($errors as $err){
				echo "<li>".$err ."</li>";
			}
			echo "</ul></div>";
		}
?>
		<form method="POST">		
			<h3><label for="subject">Betreff:<span id="required">*</span></label></h3>
			<input id="subject" name="subject" style="width: 100%" value="<?php echo (isset($_POST['subject'])? $_POST['subject'] : ""); ?>" placeholder="Neue Spammail"></input>
					
			<h3><label for="body">Text:<span id="required">*</span></label></h3>				
			<textarea id="body" name="body" style="width: 100%; resize: vertical;" rows="10" placeholder="Deine Infos über (ir)relevante Fußballinformationen"><?php echo (isset($_POST['body'])? $_POST['subject'] : ""); ?></textarea>
			
			<div style="float: left">
				<h3>Wähle eine Vordefinition:<span id="required">*</span><br /></h3>
				<h4>Vereinsmitglied?:</h4>				
				<input type="radio" id="all" name="member" value="all" <?php echo(isset($_POST['member']) && $_POST['member'] == 'all' ? 'checked' : ''); ?>>
				<label for="all">An Alle</label><br />
				<input type="radio" id="member" name="member" value="member" <?php echo(isset($_POST['member']) && $_POST['member'] == 'member' ? 'checked' : ''); ?>>
				<label for="member">An Vereinsmitglieder</label><br />
				<input type="radio" id="nonMember" name="member" value="nonMember" <?php echo(isset($_POST['member']) && $_POST['member'] == 'nonMember' ? 'checked' : ''); ?>>
				<label for="nonMember">An Nicht-Vereinsmitglieder</label><br /><br />
				
				<h4>Mailinglist?:</h4>
<?php
					echo $list;
?>				<br />
				
				<h3>Option:</h3>
				<input type="checkbox" id="option" name="both" value="option" <?php echo(isset($_POST['both']) ? 'checked' : ''); ?>>
				<label for="option">Sollen die Empfänger beide Vordefinitionen erfüllen?</label><br />
			</div>
			<div style="text-align: right; float: right">
				<h3>...oder wähle die Empfänger selbst:<span id="required">*</span></h3>
				<select name="recipients[]" size="7" onchange="checkCustom()" multiple>
					<option value="select" <?php echo (!isset($_POST['recipients']) || (isset($_POST['recipients']) && in_array('select', $_POST['recipients'])) ? 'selected' : ''); ?>>Bitte Auswählen:</option>
<?php
					echo $people;
?>
				</select>
				<h5>Halte 'Strg' gedrückt zur Mehrfachauswahl</h5>
			</div>
			<div style="clear: both; padding-top: 15px;">
				<center><input name="submit" type="submit" value="Mails verschicken" /></center>
			</div>
		</form>
	</div>
<?php
}
else{
	echo "";
}
?>
</body>
</html>
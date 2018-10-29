<?php
require_once("../functions/dbCredentials.php");  // created variables to login
require_once("../functions/dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$result = mysqli_query($con, "SELECT club_id, club_name FROM football_clubs");
if (!$result)  {
	die("An Error occurred while getting the Football Teams. Error: '" . mysqli_error($con) . "'");
}

$output = "";
while ($row = mysqli_fetch_assoc($result))  {
	$id = $row['club_id'];
	$name = $row['club_name'];
	$output .= "\t\t\t<option value='$id'>$name</option>\n";
}

mysqli_free_result($result);
mysqli_close($con);

// Error Handling
$error = "";
if (isset($_GET['error']))  {
	$error = $_GET['error'];
}
?>

<html>
<head>
	<title>Fussballfans</title>
	<meta charset="UTF-8"></meta>
	<style>
		h1{
			font-family: Arial;
			font-size: 50px;
			text-align: center;
			color: #228B22;
		}
		h3 {
			font-family: Arial;
			font-size: 30px;
			text-align: center;
			color: #228B22;
		}
		body, option, input {
			font-family: Arial;
			font-size: 20px;
		}
		body {
			text-align: center;
		}
		.button {
			font-family: Arial;
			font-size: 30px;
			text-align: center;
			height:50px;
			width:120px;
			border: none;
			border-radius: 12px;
			color: white;
			background-color: #4CAF50;
			transition-duration: 0.4s;
			cursor: pointer;
		}
		.buttonVote {
			background-color: white; 
			color: black; 
			border: 2px solid #4CAF50;
		}
		.buttonVote:hover {
			background-color: #4CAF50;
			color: white;
		}
		
		div#error  {
			background-color: #d25656;
			margin-bottom: 10px;
		}
	</style>
</head>
<body>
	<a href="./" style="text-decoration: none;"><h1>Wähle deinen Lieblingsverein!</h1></a>
	<div id="error"><?php echo $error; ?></div>
	<form action="validateClub.php" method="POST">
		<input type="hidden" name="check" value="" />
		<select name="club" id="clubs" size=7 onchange="checkCustom()">
<?php
			echo $output;
?>
			<option value='other'>Other</option>
		</select>
		
		<div id="custom" style="display: none;">
			<h3>Sag uns deinen Verein:</h3>
			<input type="text" name="newClub" maxlength=64 placeholder="Dein Verein">
		</div>
		<br><br>
		<input class="button buttonVote" type="submit" value ="Vote!" name="vote" size=20 onclick="verifyInput()" />
	</form>
	Die aktuellen Ergebnisse kannst du dir <a href="results.php" target="_blank">hier</a> ansehen.
			
	<script type="text/javascript">
		function checkCustom() {
			var x = document.getElementById("clubs").value;
			if (x == "other")  {
				document.getElementById("custom").style.display="block";
			}  else  {
				document.getElementById("custom").style.display="none";
			}
		}
		
		function verifyInput()  {
			var check = document.getElementsByName("check")[0];
			if (check != null)  {
				var club = document.getElementsByName("club")[0];
				if (club != null)  {
					var optionIndex = club.selectedIndex;
					if (optionIndex != -1) {
						var clubName = club.options[optionIndex].text;
						check.value = clubName;
						console.log(check);
					}
				}
			}
		}
	</script>
</body>
</html>
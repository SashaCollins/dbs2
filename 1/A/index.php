<?php
require_once("dbCredentials.php");  // created variables to login
require_once("dbConnect.php");

$con = open_connection($servername, $username, $password, $database);

$result = mysqli_query($con, "SELECT club_id, club_name FROM football_clubs");
if (!$result)  {
	die("An Error occurred while getting the Football Teams. Error: '" . mysqli_error($connection)) . "'";
}

$output = "";
while ($row = mysqli_fetch_assoc($result))  {
	$id = $row['club_id'];
	$name = $row['club_name'];
	$output .= "\t\t\t<option value='$id'>$name</option>\n";
}

mysqli_free_result($result);
mysqli_close($con);
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
	</style>
</head>
<body>
	<h1>Wähle deinen Lieblingsverein!</h1>
	<form action="validateClub.php" method="POST">
		<select name="club" id="clubs" size=7 onchange="checkCustom()">
<?php
			echo $output;
?>
			<option value='other'>Other</option>
		</select>
	
		<div id="custom" style="display: none;">
			<h3>Sag uns deinen Verein:</h3>
			<input type="text" name="newClub" placeholder="Dein Verein">
		</div>
		
		<script>
			function checkCustom() {
				var x = document.getElementById("clubs").value;
				if(x=="other")
					document.getElementById("custom").style.display="block";
				else
					document.getElementById("custom").style.display="none";
			}
		</script>
		
		<br><br>
		<button class="button buttonVote" type="submit" name="vote" size=20>Vote!</button>
	</form>
</body>
</html>
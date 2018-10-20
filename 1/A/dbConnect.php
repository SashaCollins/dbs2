<?php
if (!function_exists('check_db'))  {
	// Check if the given database exists, if not try to create it.
	function check_db($connection, $database)  {
		// mysqli_select_db will return false if database does not exist
		$db = mysqli_select_db($connection, $database);

		if (!$db)  {
			$sql_create = 'CREATE DATABASE ' . $database;
			$was_created = mysqli_query($connection, $sql_create);
			if ($was_created)  {
				return $database;
			}
			return false;
		}
		return $database;
    }
}

if (!function_exists('open_connection'))  {
	function open_connection($servername, $username, $password, $database)  {
		$con = mysqli_connect($servername, $username, $password);
		if (!$con) {
			die("Connection failed: " . mysqli_connect_error());
		}
		
		$newDB = check_db($con, $database);
		if (!$newDB)  {
			die("An Error occurred while creating the database " . $database . ": " . mysqli_error($con));
		}
		
		// Select the DB which exists as of now
		mysqli_select_db($con, $newDB);
		
		// Init all Tables
		init_tables($con);
		return $con;
	}
}

if (!function_exists('init_tables'))  {
	function init_tables($connection)  {
		init_football($connection);
	}
}

if (!function_exists('init_football'))  {
	function init_football($connection)  {
		$table_name = "football_clubs";
		$sql_table_exits = "SELECT 1 FROM " . $table_name . " LIMIT 1;";
		$table_exits = mysqli_query($connection, $sql_table_exits);
		
		// We know about IF NOT EXISTS but we don't want to add the initial data too often
		if (!$table_exits)  {
			// TODO Transaction
			$football_table = "CREATE TABLE `". $table_name ."` (
			  `club_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
			  `club_name` varchar(64) COLLATE utf8_german2_ci NOT NULL,
			  `club_votes` int(11) NOT NULL DEFAULT '0'
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;";
			
			if (!mysqli_query($connection, $football_table))  {
				die("An Error occurred while creating the Football Table. Error: '" . mysqli_error($connection)) . "'";
			}
			
			// If Strings are not displayed correctly, open my.ini for mysql and uncomment all UTF8 config lines 
			$football_insert = "INSERT INTO `". $table_name ."` (`club_id`, `club_name`, `club_votes`) VALUES
				(NULL, 'Bayern München', '0'), (NULL, 'FC Augsburg', '0'), (NULL, 'Schalke 04', '0'),
				(NULL, 'Borussia Dortmund', '0'), (NULL, 'Dynamo Dresden', '0'), (NULL, 'RB Leipzig', '0'), (NULL, 'TSV 1860 München', '0');";
			
			if (!mysqli_query($connection, $football_insert))  {
				die("An Error occurred while inserting Data into the Football Table. Error: '" . mysqli_error($connection)) . "'";
			}
		}
		return true;
	}
}
?> 
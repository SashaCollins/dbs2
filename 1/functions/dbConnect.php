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

if (!function_exists('check_table'))  {
	function check_table($connection, $table_name)  {
		$sql_table_exits = "SELECT 1 FROM " . $table_name . " LIMIT 1;";
		$table_exits = mysqli_query($connection, $sql_table_exits);
		return ($table_exits != false ? true : false);
	}
}

if (!function_exists('init_tables'))  {
	function init_tables($connection)  {
		// 1A
		init_football($connection);
		
		// 1B
		init_newsletter($connection);
		init_mailinglist($connection);
		init_newsletter_mailing_mapping($connection);
	}
}

if (!function_exists('init_football'))  {
	function init_football($connection)  {
		$table_name = "football_clubs";
		$table_exits = check_table($connection, $table_name);
		
		// We know about IF NOT EXISTS but we don't want to add the initial data too often
		if (!$table_exits)  {
			// Lock Database
			mysqli_autocommit($connection, false);
			//mysqli_begin_transaction($con);
			
			$football_table = "CREATE TABLE `". $table_name ."` (
				`club_id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
				`club_name` varchar(64) COLLATE utf8_german2_ci NOT NULL,
				`club_votes` int(11) NOT NULL DEFAULT '0'
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;";
			
			if (!mysqli_query($connection, $football_table))  {
				die("An Error occurred while creating the Football Table. Error: '" . mysqli_error($connection) . "'");
			}
			
			// If Strings are not displayed correctly, open my.ini for mysql and uncomment all UTF8 config lines 
			$football_insert = "INSERT INTO `". $table_name ."` (`club_name`) VALUES
				('Bayern München'), ('FC Augsburg'), ('Schalke 04'), ('Borussia Dortmund'),
				('Dynamo Dresden'), ('RB Leipzig'), ('TSV 1860 München');";
			
			if (!mysqli_query($connection, $football_insert))  {
				die("An Error occurred while inserting Data into the Football Table. Error: '" . mysqli_error($connection) . "'");
			}
			
			// Commit
			mysqli_commit($connection);
		}
		return true;
	}
}

if (!function_exists('init_newsletter'))  {
	function init_newsletter($connection)  {
		$table_name = "newsletter";
		$table_exits = check_table($connection, $table_name);
		
		// We know about IF NOT EXISTS but we don't want to add the initial data too often
		if (!$table_exits)  {
			$newsletter_table = "CREATE TABLE `". $table_name ."` (
				`person_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				`person_name` VARCHAR(64) NOT NULL,
				`email` VARCHAR(64) NOT NULL,
				`club_member` ENUM('false', 'true') NOT NULL DEFAULT 'false'
			) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_german2_ci;";
			
			if (!mysqli_query($connection, $newsletter_table))  {
				die("An Error occurred while creating the Newsletter Table. Error: '" . mysqli_error($connection) . "'");
			}
		}
		return true;
	}
}

if (!function_exists('init_mailinglist'))  {
	function init_mailinglist($connection)  {
		$table_name = "mailinglists";
		$table_exits = check_table($connection, $table_name);
		
		// We know about IF NOT EXISTS but we don't want to add the initial data too often
		if (!$table_exits)  {
			// Lock Database
			mysqli_autocommit($connection, false);
			//mysqli_begin_transaction($con);
			
			$mailinglist_table = "CREATE TABLE `". $table_name ."` (
				`mailinglist_id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
				`mailinglist_name` VARCHAR(32) NOT NULL
			) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_german2_ci;";
			
			if (!mysqli_query($connection, $mailinglist_table))  {
				die("An Error occurred while creating the Mailinglist Table. Error: '" . mysqli_error($connection) . "'");
			}
			
			// If Strings are not displayed correctly, open my.ini for mysql and uncomment all UTF8 config lines 
			$maillinglist_insert = "INSERT INTO `". $table_name ."` (`mailinglist_name`) VALUES
				('1. Liga'), ('2. Liga'), ('3. Liga'), ('Regionalliga Bayern'),
				('EM 2020'), ('Deutsche Nationalmannschaft');";
			
			if (!mysqli_query($connection, $maillinglist_insert))  {
				die("An Error occurred while inserting Data into the Mailinglist Table. Error: '" . mysqli_error($connection) . "'");
			}
			
			// Commit
			mysqli_commit($connection);
		}
		return true;
	}
}

if (!function_exists('init_newsletter_mailing_mapping'))  {
	function init_newsletter_mailing_mapping($connection)  {
		$table_name = "newsletter_mailing_mapping";
		$table_exits = check_table($connection, $table_name);
		
		// We know about IF NOT EXISTS but we don't want to add the initial data too often
		if (!$table_exits)  {
			$newsletter_table = "CREATE TABLE `". $table_name ."` (
				`person_id` int(11) NOT NULL,
				`mailinglist_id` int(11) NOT NULL,
				PRIMARY KEY (`person_id`, `mailinglist_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_german2_ci;";
			
			if (!mysqli_query($connection, $newsletter_table))  {
				die("An Error occurred while creating the Newsletter-Mailinglist-Mapping Table. Error: '" . mysqli_error($connection) . "'");
			}
		}
		return true;
	}
}

?> 
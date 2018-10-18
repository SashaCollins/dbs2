 <?php
$servername = "localhost";
$username = "dbs2";
$password = "test123$";
$database = "dbs2";

// Create connection
$conn = mysqli_connect($servername, $username, $password);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Make my_db the current database
$db_selected = mysqli_select_db($conn, $database);

if (!$db_selected) {
  $sql = 'CREATE DATABASE ' . $database;

  if (mysqli_query($conn, $sql)) {
      echo "Database my_db created successfully\n";
  } else {
      echo 'Error creating database: ' . mysqli_error() . "\n";
  }
}
?> 
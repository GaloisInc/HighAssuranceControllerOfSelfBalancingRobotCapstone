<?php

include 'dhp.php';

//header('Content-Type: application/json');


// Check if the form is submitted 
//if ( isset( $_POST['submit'] ) ) { // retrieve the form data by using the element's name attributes value as key $firstname = $_POST['firstname']; $lastname = $_POST['lastname']; // display the results
 //   echo '<h3>Form POST Method</h3>';
 //    echo 'Your name is ' . $lastname . ' ' . $firstname; exit; 
 //   } 



$name = mysqli_real_escape_string($conn, $_POST['named']);

$qdate = date('Y-m-d');
$table_name = $qdate." ".$name;
$_table_name = mysqli_real_escape_string($conn, $table_name);

$query = "CREATE TABLE `$_table_name` SELECT * FROM OtisData";

mysqli_query($conn, $query);

mysqli_close($conn);

?>



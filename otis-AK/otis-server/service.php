<?php

include 'dhp.php';

header('Content-Type: application/json');

$sql = "SELECT id, PITCH, YAW FROM OtisData ORDER BY id DESC LIMIT 1";

$result = mysqli_query($conn,$sql);

$data = array();

foreach ($result as $row) {
	$data[] = $row;
}

mysqli_close($conn);

echo json_encode($data, JSON_NUMERIC_CHECK);
?>
<?php
include 'koneksi.php';

$sql = "SELECT * FROM venues";
$result = $conn->query($sql);

$venues = array();
while($row = $result->fetch_assoc()) {
    $venues[] = $row;
}

echo json_encode($venues);
?>
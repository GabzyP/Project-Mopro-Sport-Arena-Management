<?php
include 'koneksi.php';

$sql = "SELECT * FROM ads ORDER BY created_at DESC";
$result = $conn->query($sql);

$ads = [];
while($row = $result->fetch_assoc()) {
    $ads[] = $row;
}

echo json_encode($ads);
?>

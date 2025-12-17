<?php
include 'koneksi.php';
$user_id = $_GET['user_id'] ?? 0;

$sql = "SELECT * FROM notifications WHERE user_id = '$user_id' ORDER BY created_at DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}
echo json_encode($data);
?>
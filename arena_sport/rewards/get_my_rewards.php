<?php
include '../config/koneksi.php';
header("Content-Type: application/json");

$user_id = $_GET['user_id'];

if (!$user_id) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT * FROM reward_history WHERE user_id = '$user_id' AND status = 'unused' ORDER BY redeemed_at DESC";
$result = $conn->query($sql);

$rewards = [];
while ($row = $result->fetch_assoc()) {
    $rewards[] = $row;
}

echo json_encode($rewards);
?>

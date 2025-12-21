<?php
include '../config/koneksi.php';
header("Content-Type: application/json");

$user_id = $_GET['user_id'];

if (!$user_id) {
    echo json_encode([]);
    exit;
}

$checkTable = $conn->query("SHOW TABLES LIKE 'reward_history'");
if ($checkTable->num_rows == 0) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT * FROM reward_history WHERE user_id = '$user_id' ORDER BY redeemed_at DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
?>

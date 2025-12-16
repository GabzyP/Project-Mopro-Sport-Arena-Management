<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';

$field_id = isset($_GET['field_id']) ? $_GET['field_id'] : '';
$date     = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

if (empty($field_id)) {
    echo json_encode([]);
    exit;
}

$conn->query("DELETE FROM bookings WHERE status = 'locked' AND created_at < (NOW() - INTERVAL 5 MINUTE)");

$sql = "SELECT start_time, status FROM bookings 
        WHERE field_id = '$field_id' 
        AND booking_date = '$date' 
        AND status IN ('booked', 'locked')";

$result = $conn->query($sql);

$booked_slots = [];
while($row = $result->fetch_assoc()) {
    $time_key = substr($row['start_time'], 0, 5); 
    $booked_slots[$time_key] = $row['status']; 
}

echo json_encode($booked_slots);
?>
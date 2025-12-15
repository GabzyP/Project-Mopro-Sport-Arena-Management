<?php
include 'koneksi.php';
header('Content-Type: application/json');

$field_id = isset($_GET['field_id']) ? $_GET['field_id'] : '';
$date     = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

if (empty($field_id)) {
    echo json_encode([]);
    exit;
}

$sql_cleanup = "DELETE FROM bookings 
                WHERE status = 'locked' 
                AND created_at < (NOW() - INTERVAL 3 MINUTE)";
$conn->query($sql_cleanup);

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
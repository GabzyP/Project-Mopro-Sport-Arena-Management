<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'koneksi.php';
date_default_timezone_set('Asia/Jakarta'); 

$field_id = isset($_GET['field_id']) ? $_GET['field_id'] : '';
$date     = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

if (empty($field_id)) {
    echo json_encode([]);
    exit;
}

$conn->query("UPDATE bookings SET status = 'cancelled' 
              WHERE status = 'locked' 
              AND locked_expires_at < NOW()");

$sql = "SELECT start_time, end_time, status FROM bookings 
        WHERE field_id = '$field_id' 
        AND booking_date = '$date' 
        AND (
            status IN ('processing', 'confirmed') 
            OR (status = 'locked' AND locked_expires_at > NOW())
        )";

$result = $conn->query($sql);

$booked_slots = [];
while($row = $result->fetch_assoc()) {
    $status = $row['status'];
    if ($status == 'processing' || $status == 'confirmed' || $status == 'locked') {
        $status = 'booked';
    }

    $start = intval(substr($row['start_time'], 0, 2));
    $end = intval(substr($row['end_time'], 0, 2));

    for ($i = $start; $i < $end; $i++) {
        $time_key = str_pad($i, 2, "0", STR_PAD_LEFT) . ":00";
        $booked_slots[$time_key] = $status;
    }
}

echo json_encode($booked_slots);
?>
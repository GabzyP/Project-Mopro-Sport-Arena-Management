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
              WHERE (status = 'locked' OR status = 'unpaid') 
              AND locked_expires_at < NOW()");

$sql = "SELECT start_time, end_time, status FROM bookings 
        WHERE field_id = '$field_id' 
        AND booking_date = '$date' 
        AND (
            status IN ('processing', 'confirmed', 'booked', 'completed') 
            OR ((status = 'locked' OR status = 'unpaid') AND locked_expires_at > NOW())
        )";

$result = $conn->query($sql);



$booked_slots = [];
while($row = $result->fetch_assoc()) {
    $db_status = $row['status'];
    

    
    $final_status = 'available';

    if ($db_status == 'processing' || $db_status == 'locked' || $db_status == 'unpaid') {
        $final_status = 'locked';
    } else if ($db_status == 'booked' || $db_status == 'confirmed' || $db_status == 'completed') {
        $final_status = 'booked';
    } else {
        continue;
    }

    $start = intval(substr($row['start_time'], 0, 2));
    $end = intval(substr($row['end_time'], 0, 2));

    for ($i = $start; $i < $end; $i++) {
        $time_key = str_pad($i, 2, "0", STR_PAD_LEFT) . ":00";
        

        if (isset($booked_slots[$time_key])) {
            if ($booked_slots[$time_key] == 'booked') continue;
        }
        
        $booked_slots[$time_key] = $final_status;
    }
}

echo json_encode($booked_slots);
?>
<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include 'koneksi.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (!isset($data['field_id']) || !isset($data['date']) || !isset($data['slots'])) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$field_id = $conn->real_escape_string($data['field_id']);
$date     = $conn->real_escape_string($data['date']);
$slots    = $data['slots']; 
$total_price = $conn->real_escape_string($data['total_price']);
$user_id  = 1; 

$booking_code = "SA-" . date("Ymd") . "-" . rand(1000, 9999);
$success_count = 0;

foreach ($slots as $time) {
    $start_time = $conn->real_escape_string($time); 
    if (strlen($start_time) == 5) $start_time .= ":00";
    
    $end_time = date('H:i:s', strtotime($start_time) + 3600); 

    $check_sql = "SELECT id FROM bookings WHERE field_id = '$field_id' AND booking_date = '$date' AND start_time = '$start_time' AND status IN ('booked', 'locked')";
    $check = $conn->query($check_sql);
    
    if ($check && $check->num_rows == 0) {
        $sql = "INSERT INTO bookings (booking_code, field_id, user_id, booking_date, start_time, end_time, status, total_price) 
                VALUES ('$booking_code', '$field_id', '$user_id', '$date', '$start_time', '$end_time', 'booked', '$total_price')";
        
        if ($conn->query($sql)) {
            $success_count++;
        }
    }
}

if ($success_count > 0) {
    echo json_encode(["status" => "success", "booking_code" => $booking_code]);
} else {
    echo json_encode(["status" => "error", "message" => "Slot penuh atau gagal. Coba lagi."]);
}
?>
<?php
include 'koneksi.php';
header("Content-Type: application/json");
date_default_timezone_set('Asia/Jakarta'); 

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $user_id = $data['user_id'];
    $field_id = $data['field_id'];
    $booking_date = $data['booking_date'];
    $start_time = $data['start_time'];
    $end_time = $data['end_time'];
    $total_price = $data['total_price'];
    
    $booking_code = "BK-" . strtoupper(substr(md5(time() . $user_id . rand(1,100)), 0, 6));

    $checkConflict = $conn->query("SELECT id FROM bookings 
                                   WHERE field_id = '$field_id' 
                                   AND booking_date = '$booking_date' 
                                   AND (start_time < '$end_time' AND end_time > '$start_time') 
                                   AND (
                                       status IN ('confirmed', 'processing') 
                                       OR (status = 'locked' AND locked_expires_at > NOW())
                                   )");

    if ($checkConflict->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "Jam tersebut sudah terisi."]);
        exit;
    }

    $expire_time = date('Y-m-d H:i:s', strtotime('+10 minutes'));

    $sql = "INSERT INTO bookings (booking_code, user_id, field_id, booking_date, start_time, end_time, total_price, payment_method, status, locked_expires_at, created_at) 
            VALUES ('$booking_code', '$user_id', '$field_id', '$booking_date', '$start_time', '$end_time', '$total_price', '0', 'locked', '$expire_time', NOW())";

    if ($conn->query($sql)) {
        $booking_id = $conn->insert_id;
        echo json_encode([
            "status" => "success", 
            "message" => "Slot diamankan.",
            "booking_id" => $booking_id,
            "booking_code" => $booking_code
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
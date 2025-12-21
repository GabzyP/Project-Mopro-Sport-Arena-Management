<?php
include '../config/koneksi.php';
date_default_timezone_set('Asia/Jakarta');

$user_id = $_POST['user_id'];
$field_id = $_POST['field_id'];
$date = $_POST['date'];
$time = $_POST['time'];

$now = date("Y-m-d H:i:s");
$checkSql = "SELECT id, locked_expires_at, status FROM bookings 
             WHERE field_id = '$field_id' AND booking_date = '$date' AND start_time = '$time'";
$checkRes = $conn->query($checkSql);

if ($checkRes->num_rows > 0) {
    $row = $checkRes->fetch_assoc();
    if ($row['status'] == 'confirmed' || $row['status'] == 'booked' || $row['status'] == 'processing' || $row['status'] == 'completed') {
        echo json_encode(["status" => "error", "message" => "Yah, slot ini baru saja diambil orang lain!"]);
        exit;
    }
    if ($row['status'] == 'locked' && $row['locked_expires_at'] > $now) {
        echo json_encode(["status" => "error", "message" => "Slot sedang diproses orang lain."]);
        exit;
    }
    if ($row['status'] == 'locked' && $row['locked_expires_at'] <= $now) {
        $conn->query("DELETE FROM bookings WHERE id = " . $row['id']);
    }
}

$expires = date("Y-m-d H:i:s", strtotime("+3 minutes"));
$end_time = date("H:i:s", strtotime($time) + 3600); 

$insertSql = "INSERT INTO bookings (user_id, field_id, booking_date, start_time, end_time, status, locked_at, locked_expires_at) 
              VALUES ('$user_id', '$field_id', '$date', '$time', '$end_time', 'locked', '$now', '$expires')";

if ($conn->query($insertSql)) {
    $booking_id = $conn->insert_id;
    echo json_encode([
        "status" => "success", 
        "booking_id" => $booking_id,
        "expires_in" => 180, 
        "message" => "Slot diamankan selama 3 menit!"
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal mengunci slot"]);
}
?>
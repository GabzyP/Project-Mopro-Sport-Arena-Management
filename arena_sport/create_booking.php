<?php
include 'koneksi.php';
header('Content-Type: application/json');

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$user_id = $data['user_id'] ?? ''; 
$field_id = $data['field_id'] ?? '';
$date = $data['booking_date'] ?? '';
$start = $data['start_time'] ?? '';
$end = $data['end_time'] ?? '';
$total = $data['total_price'] ?? 0;
$payment = $data['payment_method'] ?? 'Transfer Bank';

if (empty($user_id) || empty($field_id)) {
    echo json_encode(["status" => "error", "message" => "Data User/Lapangan tidak lengkap"]);
    exit;
}

$code = "SA-" . date("Ymd") . "-" . rand(1000, 9999);

$sql = "INSERT INTO bookings (booking_code, user_id, field_id, booking_date, start_time, end_time, total_price, status, payment_method) 
        VALUES ('$code', '$user_id', '$field_id', '$date', '$start', '$end', '$total', 'booked', '$payment')";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Booking Berhasil", "booking_code" => $code]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal: " . $conn->error]);
}
?>
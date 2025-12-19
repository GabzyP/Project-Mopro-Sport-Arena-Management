<?php
include 'koneksi.php';
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $user_id = $data['user_id'];
    $field_id = $data['field_id'];
    $booking_date = $data['booking_date'];
    $start_time = $data['start_time'];
    $end_time = $data['end_time'];
    $total_price = $data['total_price'];
    $payment_method = $data['payment_method'];
    
    $booking_code = "BK-" . strtoupper(substr(md5(time()), 0, 6));

    $sql = "INSERT INTO bookings (booking_code, user_id, field_id, booking_date, start_time, end_time, total_price, payment_method, status) 
            VALUES ('$booking_code', '$user_id', '$field_id', '$booking_date', '$start_time', '$end_time', '$total_price', '$payment_method', 'pending')";

    if ($conn->query($sql)) {
        $msg = "Pesanan $booking_code dibuat. Segera lakukan pembayaran via $payment_method.";
        $conn->query("INSERT INTO notifications (user_id, title, message, category, is_read, created_at) 
                      VALUES ('$user_id', 'Menunggu Pembayaran', '$msg', 'booking', '0', NOW())");

        echo json_encode(["status" => "success", "booking_code" => $booking_code]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menyimpan"]);
    }
}
?>
<?php
include 'koneksi.php';
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['id']) && isset($data['status'])) {
    $id = $data['id'];
    $status = $data['status'];

    $sql = "UPDATE bookings SET status = '$status' WHERE id = '$id'";

    if ($conn->query($sql)) {
        $res = $conn->query("SELECT user_id, booking_code FROM bookings WHERE id = '$id'");
        $booking = $res->fetch_assoc();
        $user_id = $booking['user_id'];
        $code = $booking['booking_code'];

        $title = "Update Status Pesanan";
        $message = "";
        if($status == 'processing') $message = "Pembayaran tiket $code diterima. Menunggu konfirmasi admin.";
        if($status == 'booked') $message = "Tiket $code TELAH DIKONFIRMASI. Silakan datang ke venue.";
        if($status == 'cancelled') $message = "Maaf, pesanan $code telah dibatalkan/ditolak.";

        $conn->query("INSERT INTO notifications (user_id, title, message, category, is_read, created_at) 
                      VALUES ('$user_id', '$title', '$message', 'booking', '0', NOW())");

        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error"]);
    }
}
?>
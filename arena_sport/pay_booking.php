<?php
include 'koneksi.php';
header("Content-Type: application/json");
date_default_timezone_set('Asia/Jakarta');

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $booking_id = $data['booking_id'];
    $payment_method_id = $data['payment_method'];
    $user_id = $data['user_id'];

    $cekBooking = $conn->query("SELECT total_price, status FROM bookings WHERE id = '$booking_id'");
    if ($cekBooking->num_rows == 0) {
        echo json_encode(["status" => "error", "message" => "Booking tidak ditemukan."]);
        exit;
    }
    $bookingRow = $cekBooking->fetch_assoc();

    if ($bookingRow['status'] == 'cancelled') {
        echo json_encode(["status" => "error", "message" => "Waktu pembayaran habis. Silakan booking ulang."]);
        exit;
    }
    if ($bookingRow['status'] == 'confirmed' || $bookingRow['status'] == 'processing') {
        echo json_encode(["status" => "success", "message" => "Sudah dibayar sebelumnya."]);
        exit;
    }

    $cekSaldo = $conn->query("SELECT balance, type FROM payment_methods WHERE id = '$payment_method_id' AND user_id = '$user_id'");
    if ($cekSaldo->num_rows == 0) {
        echo json_encode(["status" => "error", "message" => "Metode pembayaran tidak valid."]);
        exit;
    }
    $methodRow = $cekSaldo->fetch_assoc();

    $harga_tiket = floatval($bookingRow['total_price']);
    $biaya_admin = 0;

    if (strpos(strtolower($methodRow['type']), 'bank') !== false || strpos(strtolower($methodRow['type']), 'va') !== false) {
        $biaya_admin = 2500;
    }

    $total_potong = $harga_tiket + $biaya_admin;
    $current_saldo = floatval($methodRow['balance']);

    if ($current_saldo < $total_potong) {
        echo json_encode([
            "status" => "error", 
            "message" => "Saldo kurang. Total: Rp " . number_format($total_potong)
        ]);
        exit;
    }

    $conn->begin_transaction();
    try {
        $new_saldo = $current_saldo - $total_potong;
        $conn->query("UPDATE payment_methods SET balance = '$new_saldo' WHERE id = '$payment_method_id'");

        $conn->query("UPDATE bookings SET 
                      status = 'processing', 
                      payment_method = '$payment_method_id', 
                      locked_expires_at = NULL, 
                      updated_at = NOW() 
                      WHERE id = '$booking_id'");

        $msg = "Pembayaran Rp " . number_format($total_potong) . " berhasil. Menunggu konfirmasi.";
        $conn->query("INSERT INTO notifications (user_id, title, message, category, is_read, created_at) VALUES ('$user_id', 'Pembayaran Berhasil', '$msg', 'booking', '0', NOW())");

        $conn->commit();
        echo json_encode(["status" => "success", "message" => "Pembayaran Berhasil!"]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
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

    $reward_id = isset($data['reward_id']) ? $data['reward_id'] : null;
    $final_price = $total_price;

    if ($reward_id) {
        $checkReward = $conn->query("SELECT * FROM reward_history WHERE id = '$reward_id' AND user_id = '$user_id' AND status = 'unused'");
        if ($checkReward->num_rows == 0) {
            echo json_encode(["status" => "error", "message" => "Reward tidak valid atau sudah digunakan."]);
            exit;
        }
    }


    $userSql = $conn->query("SELECT points FROM users WHERE id = '$user_id'");
    $userPoints = 0;
    if ($userSql->num_rows > 0) {
        $uData = $userSql->fetch_assoc();
        $userPoints = intval($uData['points']);
    }

    $levelDiscountPercent = 0;
    if ($userPoints >= 100000) {
        $levelDiscountPercent = 20;
    } else if ($userPoints >= 10000) {
        $levelDiscountPercent = 15;
    } else if ($userPoints >= 2000) { 
        $levelDiscountPercent = 10;
    } else if ($userPoints >= 500) {
        $levelDiscountPercent = 5;
    }
    
    $levelDiscountAmount = ($total_price * $levelDiscountPercent) / 100;



    $adSql = "SELECT * FROM ads WHERE is_active = 1 AND promo_type = 'discount' AND (start_date IS NULL OR start_date <= CURDATE()) AND (end_date IS NULL OR end_date >= CURDATE()) ORDER BY promo_value DESC LIMIT 1";
    $adResult = $conn->query($adSql);
    $adDiscountAmount = 0;
    
    if ($adResult->num_rows > 0) {
        $ad = $adResult->fetch_assoc();
        $discountPercent = floatval($ad['promo_value']);
        $adDiscountAmount = ($total_price * $discountPercent) / 100;
    }

    $finalDiscount = max($levelDiscountAmount, $adDiscountAmount);
    $total_price -= $finalDiscount;


    $checkConflict = $conn->query("SELECT id FROM bookings 
                                   WHERE field_id = '$field_id' 
                                   AND booking_date = '$booking_date' 
                                   AND (start_time < '$end_time' AND end_time > '$start_time') 
                                   AND (
                                       status IN ('confirmed', 'processing', 'booked', 'completed') 
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

        if ($reward_id) {
            $conn->query("UPDATE reward_history SET status = 'used' WHERE id = '$reward_id'");
        }

        $notifTitle = "Segera Selesaikan Pembayaran";
        $notifMsg = "Booking $booking_code berhasil dibuat. Segera lakukan pembayaran sebelum 10 menit atau booking akan hangus.";
        $conn->query("INSERT INTO notifications (user_id, title, message, category, is_read, created_at) VALUES ('$user_id', '$notifTitle', '$notifMsg', 'booking', '0', NOW())");

        echo json_encode([
            "status" => "success", 
            "message" => "Slot diamankan.",
            "booking_id" => $booking_id,
            "booking_code" => $booking_code,
            "total_price" => $total_price
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal: " . $conn->error]);
    }

} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
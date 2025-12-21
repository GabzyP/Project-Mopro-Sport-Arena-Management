<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include '../config/koneksi.php';
date_default_timezone_set('Asia/Jakarta'); 

$field_id = isset($_GET['field_id']) ? $_GET['field_id'] : '';
$date     = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

if (empty($field_id)) {
    echo json_encode([]);
    exit;
}

$expired_processing = $conn->query("SELECT id, user_id, total_price, payment_method, booking_date, start_time 
                                    FROM bookings 
                                    WHERE status = 'processing' 
                                    AND CONCAT(booking_date, ' ', start_time) < NOW()");

if ($expired_processing->num_rows > 0) {
    while($row = $expired_processing->fetch_assoc()) {
        $b_id = $row['id'];
        $u_id = $row['user_id'];
        $pm_id = $row['payment_method'];
        $amount = floatval($row['total_price']);

        $pmSql = $conn->query("SELECT type FROM payment_methods WHERE id = '$pm_id'");
        if ($pmSql->num_rows > 0) {
            $pmData = $pmSql->fetch_assoc();
            $type = strtolower($pmData['type']);
            if (strpos($type, 'bank') !== false || strpos($type, 'va') !== false) {
                $amount += 2500;
            }
        
            $conn->query("UPDATE payment_methods SET balance = balance + $amount WHERE id = '$pm_id'");
        }

        $title = "Booking Dibatalkan & Refund";
        $msg = "Maaf, booking tiket pada " . $row['booking_date'] . " " . $row['start_time'] . 
               " dibatalkan karena tidak dikonfirmasi admin hingga jadwal lewat. Saldo Rp " . number_format($amount) . " telah dikembalikan.";
        
        $conn->query("INSERT INTO notifications (user_id, title, message, category, is_read, created_at) 
                      VALUES ('$u_id', '$title', '$msg', 'system', '0', NOW())");

        $conn->query("UPDATE bookings SET status = 'cancelled' WHERE id = '$b_id'");
    }
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
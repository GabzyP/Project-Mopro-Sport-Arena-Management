<?php
include 'koneksi.php';

$stats = [];
$stats['total_revenue'] = $conn->query("SELECT SUM(total_price) FROM bookings WHERE status IN ('booked', 'confirmed', 'completed')")->fetch_row()[0] ?? 0;
$stats['today_bookings'] = $conn->query("SELECT COUNT(*) FROM bookings WHERE booking_date = CURDATE()")->fetch_row()[0] ?? 0;
$stats['active_users'] = $conn->query("SELECT COUNT(*) FROM users WHERE role = 'customer' AND status = 'active'")->fetch_row()[0] ?? 0;
$stats['pending_orders'] = $conn->query("SELECT COUNT(*) FROM bookings WHERE status = 'booked'")->fetch_row()[0] ?? 0; // 'booked' kita anggap pending verifikasi jika ada fitur manual

$orders_sql = "SELECT b.id, b.booking_code, b.booking_date, b.start_time, b.end_time, 
                      b.total_price, b.status, b.payment_method, 
                      u.name as customer_name, u.phone as customer_phone, 
                      f.name as field_name, f.sport_type 
               FROM bookings b
               JOIN users u ON b.user_id = u.id
               JOIN fields f ON b.field_id = f.id
               ORDER BY b.created_at DESC";

$orders_result = $conn->query($orders_sql);
$orders = [];
while($row = $orders_result->fetch_assoc()) {
    $orders[] = $row;
}

$users_sql = "SELECT id, name, email, phone, status, created_at FROM users WHERE role = 'customer' ORDER BY created_at DESC";
$users_result = $conn->query($users_sql);
$users = [];
while($row = $users_result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode([
    "status" => "success",
    "stats" => $stats,
    "orders" => $orders,
    "customers" => $users
]);
?>
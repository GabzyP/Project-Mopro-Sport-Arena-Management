<?php
include 'koneksi.php';

$stats = [];
$stats['total_revenue'] = $conn->query("SELECT SUM(total_price) FROM bookings WHERE status IN ('booked', 'confirmed', 'completed')")->fetch_row()[0] ?? 0;
$stats['today_bookings'] = $conn->query("SELECT COUNT(*) FROM bookings WHERE booking_date = CURDATE() AND status IN ('booked', 'confirmed', 'processing', 'completed')")->fetch_row()[0] ?? 0;
$stats['active_users'] = $conn->query("SELECT COUNT(*) FROM users WHERE role = 'customer' AND status = 'active'")->fetch_row()[0] ?? 0;
$stats['pending_orders'] = $conn->query("SELECT COUNT(*) FROM bookings WHERE status = 'processing'")->fetch_row()[0] ?? 0;

$orders_sql = "SELECT b.id, b.booking_code, b.booking_date, b.start_time, b.end_time, 
                      b.total_price, b.status, 
                      COALESCE(pm.name, CASE WHEN b.payment_method REGEXP '^[0-9]+\$' THEN 'Tunai' ELSE b.payment_method END) as payment_method, 
                      u.name as customer_name, u.phone as customer_phone, 
                      f.name as field_name, f.sport_type 
               FROM bookings b
               JOIN users u ON b.user_id = u.id
               JOIN fields f ON b.field_id = f.id
               LEFT JOIN payment_methods pm ON b.payment_method = pm.id
               ORDER BY b.created_at DESC";

$orders_result = $conn->query($orders_sql);
$orders = [];
while($row = $orders_result->fetch_assoc()) {
    $orders[] = $row;
}

$users_sql = "SELECT u.id, u.name, u.email, u.phone, u.status, u.created_at, 
               (SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.id) as booking_count 
               FROM users u 
               WHERE u.role = 'customer' 
               ORDER BY u.created_at DESC";
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
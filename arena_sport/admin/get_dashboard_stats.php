<?php
include '../config/koneksi.php';

$sql_revenue = "SELECT SUM(total_price) as total FROM bookings WHERE status = 'completed'";
$revenue = $conn->query($sql_revenue)->fetch_assoc()['total'] ?? 0;

$today = date('Y-m-d');
$sql_today = "SELECT COUNT(*) as total FROM bookings WHERE booking_date = '$today'";
$today_count = $conn->query($sql_today)->fetch_assoc()['total'] ?? 0;

$sql_pop = "SELECT f.name, COUNT(b.id) as total_book 
            FROM bookings b 
            JOIN fields f ON b.field_id = f.id 
            GROUP BY field_id 
            ORDER BY total_book DESC LIMIT 1";
$popular = $conn->query($sql_pop)->fetch_assoc();
$popular_name = $popular ? $popular['name'] : "-";

echo json_encode([
    "total_revenue" => "Rp " . number_format($revenue, 0, ',', '.'),
    "today_bookings" => $today_count,
    "popular_court" => $popular_name
]);
?>
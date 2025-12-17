<?php
include 'koneksi.php';
$user_id = $_GET['user_id'] ?? 0;

$sql = "SELECT b.*, f.name as field_name, f.sport_type, f.image_url 
        FROM bookings b 
        JOIN fields f ON b.field_id = f.id 
        WHERE b.user_id = '$user_id' 
        ORDER BY b.booking_date DESC, b.start_time DESC";

$result = $conn->query($sql);
$data = [];
while($row = $result->fetch_assoc()) { $data[] = $row; }
echo json_encode($data);
?>
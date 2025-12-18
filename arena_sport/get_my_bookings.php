<?php
include 'koneksi.php';
header('Content-Type: application/json');

$user_id = $_GET['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT b.*, f.name as field_name, f.sport_type, v.name as venue_name, v.image_url 
        FROM bookings b
        JOIN fields f ON b.field_id = f.id
        JOIN venues v ON f.venue_id = v.id
        WHERE b.user_id = '$user_id' 
        ORDER BY b.booking_date DESC, b.start_time DESC";

$result = $conn->query($sql);

$bookings = array();
while($row = $result->fetch_assoc()) {
    $bookings[] = $row;
}

echo json_encode($bookings);
?>
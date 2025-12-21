<?php
include 'koneksi.php';
header('Content-Type: application/json');

$user_id = $_GET['user_id'] ?? '';
$sql = "SELECT b.*, f.name AS field_name, v.name AS venue_name 
        FROM bookings b
        JOIN fields f ON b.field_id = f.id
        JOIN venues v ON f.venue_id = v.id
        WHERE b.user_id = '$user_id' 
        ORDER BY b.booking_date DESC";
        
if (empty($user_id)) {
    echo json_encode([]);
    exit;
}

date_default_timezone_set('Asia/Jakarta');
$now = date('Y-m-d H:i:s');
$conn->query("UPDATE bookings SET status = 'cancelled' WHERE (status = 'locked' OR status = 'unpaid') AND locked_expires_at < '$now'");
$result = $conn->query($sql);

$bookings = array();
while($row = $result->fetch_assoc()) {
    $bookings[] = $row;
}

echo json_encode($bookings);
?>
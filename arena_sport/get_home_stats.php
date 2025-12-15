<?php
include 'koneksi.php';

$resVenue = $conn->query("SELECT COUNT(*) as total FROM venues");
$rowVenue = $resVenue->fetch_assoc();

$resField = $conn->query("SELECT COUNT(*) as total FROM fields");
$rowField = $resField->fetch_assoc();

$today = date('Y-m-d');
$resBooked = $conn->query("SELECT COUNT(*) as total FROM bookings WHERE booking_date = '$today' AND status IN ('booked', 'locked')");
$rowBooked = $resBooked->fetch_assoc();

$capacity = 50; 
$percent = 100;
if ($rowBooked['total'] > 0) {
    $percent = round(100 - (($rowBooked['total'] / $capacity) * 100));
}

echo json_encode([
    "total_venues" => $rowVenue['total'],
    "total_fields" => $rowField['total'],
    "availability" => $percent . "%"
]);
?>
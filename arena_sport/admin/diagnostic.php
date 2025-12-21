<?php
include '../config/koneksi.php';

echo "--- DIAGNOSTIC START ---\n";

$result = $conn->query("SHOW COLUMNS FROM users LIKE 'points'");
if ($result->num_rows > 0) {
    echo "[PASS] Column 'points' exists in 'users'.\n";
} else {
    echo "[FAIL] Column 'points' MISSING in 'users'.\n";
}

echo "\n--- User Points ---\n";
$resUsers = $conn->query("SELECT id, name, points FROM users LIMIT 5");
while($row = $resUsers->fetch_assoc()) {
    echo "User ID: " . $row['id'] . " | Name: " . $row['name'] . " | Points: " . ($row['points'] ?? 'NULL') . "\n";
}

echo "\n--- Booking Price Format Check ---\n";
$resBookings = $conn->query("SELECT id, total_price, status FROM bookings ORDER BY id DESC LIMIT 5");
while($row = $resBookings->fetch_assoc()) {
    $price = $row['total_price'];
    $floatPrice = floatval($price);
    $calculatedPoints = floor($floatPrice / 1000);
    
    echo "ID: " . $row['id'] . " | Status: " . $row['status'] . " | Raw Price: '$price' | Float: $floatPrice | Calc Points: $calculatedPoints\n";
}

echo "--- DIAGNOSTIC END ---\n";
?>

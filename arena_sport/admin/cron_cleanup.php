<?php
include '../config/koneksi.php';

$sql = "DELETE FROM bookings WHERE status = 'locked' AND created_at < (NOW() - INTERVAL 5 MINUTE)";

if ($conn->query($sql) === TRUE) {
    echo "Cleanup successful. Deleted rows: " . $conn->affected_rows;
} else {
    echo "Error cleaning up: " . $conn->error;
}
?>
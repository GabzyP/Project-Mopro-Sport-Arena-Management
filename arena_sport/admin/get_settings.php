<?php
include '../config/koneksi.php';

$sql = "SELECT * FROM admin_settings LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo json_encode($result->fetch_assoc());
} else {
    echo json_encode(["push_notif" => 1, "auto_confirm" => 0]);
}
?>

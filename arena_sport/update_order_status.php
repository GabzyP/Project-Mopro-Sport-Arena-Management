<?php
include 'koneksi.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$id = $data['id'];
$status = $data['status'];

$sql = "UPDATE bookings SET status = '$status' WHERE id = '$id'";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Status pesanan diperbarui"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal update"]);
}
?>
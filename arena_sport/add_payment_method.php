<?php
include 'koneksi.php';

$user_id = $_POST['user_id'];
$name    = $_POST['name'];
$type    = $_POST['type']; 
$balance = $_POST['balance'];
$image   = $_POST['image_url'];

if (!$user_id || !$name) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO payment_methods (user_id, name, type, balance, image_url) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("issss", $user_id, $name, $type, $balance, $image);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Metode berhasil ditambahkan"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal: " . $stmt->error]);
}
?>
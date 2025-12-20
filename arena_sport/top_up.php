<?php
include 'koneksi.php';

$id = $_POST['id'];
$amount = $_POST['amount'];

if (!$id || !$amount) {
    echo json_encode(["status" => "error", "message" => "Data kurang"]);
    exit;
}

$stmt = $conn->prepare("UPDATE payment_methods SET balance = balance + ? WHERE id = ?");
$stmt->bind_param("di", $amount, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Top Up Berhasil"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal Top Up"]);
}
?>
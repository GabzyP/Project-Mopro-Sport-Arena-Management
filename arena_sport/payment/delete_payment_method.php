<?php
include '../config/koneksi.php';

$id = $_POST['id'];

if (!$id) {
    echo json_encode(["status" => "error", "message" => "ID tidak ditemukan"]);
    exit;
}

$stmt = $conn->prepare("DELETE FROM payment_methods WHERE id = ?");
$stmt->bind_param("i", $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Dihapus"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal menghapus"]);
}
?>
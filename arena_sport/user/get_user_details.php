<?php
include '../config/koneksi.php';
header("Content-Type: application/json");

$user_id = $_GET['user_id'] ?? $_GET['id'];

$sql = "SELECT * FROM users WHERE id = '$user_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    if ($row['saldo'] <= 0) {
        $random_saldo = rand(500000, 2000000);
        $conn->query("UPDATE users SET saldo = '$random_saldo' WHERE id = '$user_id'");
        $row['saldo'] = $random_saldo;
    }

    echo json_encode($row);
} else {
    echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
}
?>
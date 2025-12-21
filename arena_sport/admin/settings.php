<?php
include '../config/koneksi.php';
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    $result = $conn->query("SELECT * FROM admin_settings WHERE id=1");
    echo json_encode(["status" => "success", "data" => $result->fetch_assoc()]);

} elseif ($method == 'POST') {
    $push = $_POST['push_notif'];
    $auto = $_POST['auto_confirm'];
    
    $sql = "UPDATE admin_settings SET push_notif = '$push', auto_confirm = '$auto' WHERE id=1";
    if ($conn->query($sql)) {
        echo json_encode(["status" => "success", "message" => "Pengaturan disimpan"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal update"]);
    }
}
?>
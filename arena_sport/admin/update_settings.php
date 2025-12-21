<?php
include '../config/koneksi.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['action'])) {
    $col = $data['action'] == 'toggle_notif' ? 'push_notif' : 'auto_confirm';
    $val = $data['value'] ? 1 : 0;
    
    $check = $conn->query("SELECT id FROM admin_settings LIMIT 1");
    if ($check->num_rows == 0) {
        $sql = "INSERT INTO admin_settings ($col) VALUES ($val)";
    } else {
        $sql = "UPDATE admin_settings SET $col = $val";
    }
    
    if ($conn->query($sql)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid Request"]);
}
?>

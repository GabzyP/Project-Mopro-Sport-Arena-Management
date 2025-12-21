<?php
include 'koneksi.php';

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type");
    exit(0);
}

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id']) || !isset($data['old_password']) || !isset($data['new_password'])) {
    echo json_encode(["status" => "error", "message" => "Incomplete data"]);
    exit();
}

$user_id = $data['user_id'];
$old_password = $data['old_password'];
$new_password = $data['new_password'];

$sql = "SELECT password FROM users WHERE id = '$user_id'";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    if (password_verify($old_password, $row['password'])) {
        $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);
        
        $update_sql = "UPDATE users SET password = '$hashed_password' WHERE id = '$user_id'";
        if ($conn->query($update_sql) === TRUE) {
             echo json_encode(["status" => "success", "message" => "Password berhasil diubah"]);
        } else {
             echo json_encode(["status" => "error", "message" => "Gagal update database"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Password lama salah"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
}
?>

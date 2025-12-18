<?php
error_reporting(0);
ini_set('display_errors', 0);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$email       = $data['email'] ?? '';
$phone       = $data['phone'] ?? '';
$newPassword = $data['new_password'] ?? '';

if (empty($email) || empty($phone) || empty($newPassword)) {
    echo json_encode(["status" => "error", "message" => "Mohon lengkapi semua data"]);
    exit;
}

$stmt = $conn->prepare("SELECT id FROM users WHERE email = ? AND phone = ?");
$stmt->bind_param("ss", $email, $phone);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userId = $row['id'];
    $stmt->close();
    $hashed_password = password_hash($newPassword, PASSWORD_DEFAULT);
    $updateStmt = $conn->prepare("UPDATE users SET password = ? WHERE id = ?");
    
    if ($updateStmt) {
        $updateStmt->bind_param("si", $hashed_password, $userId);
        
        if ($updateStmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Password berhasil diubah. Silakan login."]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal mengupdate password di database."]);
        }
        $updateStmt->close();
    } else {
        echo json_encode(["status" => "error", "message" => "Terjadi kesalahan sistem (Prepare Failed)."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Email atau No. Telepon tidak cocok."]);
}

$conn->close();
?>
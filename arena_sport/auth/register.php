<?php
error_reporting(0);
ini_set('display_errors', 0);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

include '../config/koneksi.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

$name     = $data['name'] ?? '';
$email    = $data['email'] ?? '';
$password = $data['password'] ?? '';
$phone    = $data['phone'] ?? ''; 
$role = 'customer';

if (empty($name) || empty($email) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$check = $conn->query("SELECT id FROM users WHERE email = '$email'");
if ($check->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "Email sudah terdaftar"]);
    exit;
}

$hashed_password = password_hash($password, PASSWORD_DEFAULT);
$sql = "INSERT INTO users (name, email, password, role, phone) VALUES ('$name', '$email', '$hashed_password', '$role', '$phone')";
$role = 'customer';

$stmt = $conn->prepare("INSERT INTO users (name, email, password, role, phone) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("sssss", $name, $email, $hashed_password, $role, $phone);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Registrasi berhasil"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal daftar: " . $conn->error]);
}
?>
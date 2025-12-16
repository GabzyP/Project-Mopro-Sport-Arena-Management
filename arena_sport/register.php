<?php
include 'koneksi.php';

$name = $_POST['name'];
$email = $_POST['email'];
$password = $_POST['password'];
$phone = isset($_POST['phone']) ? $_POST['phone'] : ''; 
$role = 'customer';

$check = $conn->query("SELECT id FROM users WHERE email = '$email'");
if ($check->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "Email sudah terdaftar"]);
    exit;
}

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

$sql = "INSERT INTO users (name, email, password, role, phone) VALUES ('$name', '$email', '$hashed_password', '$role', '$phone')";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Registrasi berhasil"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal daftar: " . $conn->error]);
}
?>
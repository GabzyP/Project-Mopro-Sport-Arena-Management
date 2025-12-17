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

$json_data = file_get_contents("php://input");
$data = json_decode($json_data, true);

$email = $data['email'] ?? null;
$password = $data['password'] ?? null;

if (empty($email) || empty($password)) {
    echo json_encode([
        'status' => 'error', 
        'message' => 'Email dan password harus diisi.'
    ]);
    exit();
}

$sql = "SELECT id, password, name, email, role, photo_profile  FROM users WHERE email = '$email'";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    if (password_verify($password, $user['password'])) {
        
        echo json_encode([
            "status" => "success", 
            "message" => "Login Berhasil!",
            "data" => [
                "id" => $user['id'],
                "name" => $user['name'],
                "email" => $user['email'], 
                "role" => $user['role'],
                "photo_profile" => $user['photo_profile'] ?? null 
            ]
        ]);
        
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Password salah."
        ]);
    }
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Email tidak ditemukan."
    ]);
}

$conn->close();
?>
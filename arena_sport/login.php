<?php
// login.php - API Login untuk Flutter

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); 
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php'; // Ganti dengan path koneksi Anda

// 1. Mengambil data dari JSON input (sesuai standar Flutter/REST)
$json_data = file_get_contents("php://input");
$data = json_decode($json_data, true);

$email = $data['email'] ?? null;
$password = $data['password'] ?? null;

// Validasi input
if (empty($email) || empty($password)) {
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'message' => 'Email dan password harus diisi.']);
    exit();
}

// 2. Query ke Database (Menggunakan prepared statement lebih aman, tapi kita pakai query biasa dulu)
// PASTIKAN KOLOM ROLE ADA DI TABEL USERS ANDA
$sql = "SELECT id, password, name, email, role FROM users WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // 3. Verifikasi Password
    if (password_verify($password, $user['password'])) {
        
        // LOGIN BERHASIL (Mengembalikan 'success' dan data role)
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Login Berhasil!",
            "user_id" => $user['id'],
            "user_role" => $user['role'] // KUNCI UTAMA: Mengirim role
        ]);
        
    } else {
        // PASSWORD SALAH
        http_response_code(200); 
        echo json_encode(["success" => false, "message" => "Email atau password salah."]);
    }
} else {
    // EMAIL TIDAK DITEMUKAN
    http_response_code(200);
    echo json_encode(["success" => false, "message" => "Email tidak ditemukan."]);
}

$conn->close();
?>
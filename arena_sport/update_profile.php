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

if (!isset($data['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Invalid request"]);
    exit();
}

$user_id = $data['user_id'];
$name = isset($data['name']) ? $conn->real_escape_string($data['name']) : null;
$email = isset($data['email']) ? $conn->real_escape_string($data['email']) : null;
$phone = isset($data['phone']) ? $conn->real_escape_string($data['phone']) : null;

$query = "UPDATE users SET ";
$updates = [];

if ($name) $updates[] = "name = '$name'";
if ($email) $updates[] = "email = '$email'";

if (empty($updates)) {
    echo json_encode(["status" => "error", "message" => "No data to update"]);
    exit();
}

$query .= implode(", ", $updates) . " WHERE id = '$user_id'";

if ($conn->query($query) === TRUE) {
    $result = $conn->query("SELECT * FROM users WHERE id = '$user_id'");
    $user = $result->fetch_assoc();
    
    echo json_encode([
        "status" => "success", 
        "message" => "Profile updated successfully",
        "data" => $user
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
}
?>

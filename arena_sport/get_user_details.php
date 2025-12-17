<?php
include 'koneksi.php';
$user_id = $_GET['user_id'] ?? 0;

$sql = "SELECT points, photo_profile, email, name FROM users WHERE id = '$user_id'";
$result = $conn->query($sql);

if ($row = $result->fetch_assoc()) {
    echo json_encode(["status" => "success", "data" => $row]);
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}
?>
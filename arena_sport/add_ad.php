<?php
include 'koneksi.php';

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $title = $data['title'];
    $description = $data['description'];
    $promo_type = $data['promo_type'] ?? 'none';
    $promo_value = $data['promo_value'] ?? 0;
    
    $image_url = 'assets/img/default_ad.jpg'; 

    $sql = "INSERT INTO ads (title, description, image_url, promo_type, promo_value, is_active, created_at) VALUES ('$title', '$description', '$image_url', '$promo_type', '$promo_value', 1, NOW())";
    
    if ($conn->query($sql)) {
        echo json_encode(["status" => "success", "message" => "Iklan berhasil ditambahkan"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid Data"]);
}
?>

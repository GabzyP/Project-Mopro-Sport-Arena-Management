<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include '../config/koneksi.php';

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (
    !isset($data['venue_id']) || 
    !isset($data['name']) || 
    !isset($data['sport_type']) || 
    !isset($data['price'])
) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$venue_id   = $data['venue_id'];
$name       = $data['name'];
$sport_type = $data['sport_type'];
$price      = $data['price'];
$image_url  = "https://images.unsplash.com/photo-1529900748604-07564a03e7a6"; 
$facilities = "WiFi, Toilet"; 

$sql = "INSERT INTO fields (venue_id, name, sport_type, price_per_hour, image_url, facilities) 
        VALUES ('$venue_id', '$name', '$sport_type', '$price', '$image_url', '$facilities')";

if ($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Lapangan berhasil ditambahkan"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal: " . $conn->error]);
}
?>
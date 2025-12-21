<?php
include '../config/koneksi.php';
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if ($data) {
    $user_id = $data['user_id'];
    $venue_name = $data['venue_name'];
    $sport_type = $data['sport_type'];
    $rating = $data['rating'];
    $comment = $data['comment'];
    
    $booking_id = isset($data['booking_id']) ? $data['booking_id'] : null;

    if ($booking_id) {
         $checkCol = $conn->query("SHOW COLUMNS FROM reviews LIKE 'booking_id'");
         if($checkCol->num_rows > 0) {
             $sql = "INSERT INTO reviews (user_id, booking_id, venue_name, sport_type, rating, comment, created_at) 
                     VALUES ('$user_id', '$booking_id', '$venue_name', '$sport_type', '$rating', '$comment', NOW())";
         } else {
             $sql = "INSERT INTO reviews (user_id, venue_name, sport_type, rating, comment, created_at) 
                     VALUES ('$user_id', '$venue_name', '$sport_type', '$rating', '$comment', NOW())";
         }
    } else {
        $sql = "INSERT INTO reviews (user_id, venue_name, sport_type, rating, comment, created_at) 
                VALUES ('$user_id', '$venue_name', '$sport_type', '$rating', '$comment', NOW())";
    }

    if ($conn->query($sql)) {
        echo json_encode(["status" => "success", "message" => "Ulasan berhasil dikirim"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal menyimpan ulasan: " . $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak valid"]);
}
?>

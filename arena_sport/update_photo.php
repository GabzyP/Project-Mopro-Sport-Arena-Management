<?php
include 'koneksi.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
    exit();
}

$user_id = $_POST['user_id'] ?? '';

if (isset($_FILES['image']) && !empty($user_id)) {
    $target_dir = "uploads/";

    if (!is_dir($target_dir)) {
        mkdir($target_dir, 0777, true);
    }

    $file_extension = pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION);
    $new_filename = "profile_" . $user_id . "_" . time() . "." . $file_extension;
    $target_file = $target_dir . $new_filename;

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $db_path = "uploads/" . $new_filename;
        
        $sql = "UPDATE users SET photo_profile = '$db_path' WHERE id = '$user_id'";
        
        if ($conn->query($sql)) {

            $base_url = "http://192.168.1.7/arena_sport"; 
            $full_url = $base_url . "/" . $db_path;

            echo json_encode([
                "status" => "success", 
                "message" => "Foto berhasil diupdate",
                "data" => [
                    "photo_url" => $full_url 
                ]
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Database error: " . $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal memindahkan file"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data user_id atau gambar kosong"]);
}
?>
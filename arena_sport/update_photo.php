<?php
include 'koneksi.php';

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Method not allowed"]);
    exit();
}

$user_id = $_POST['user_id'] ?? '';

if (isset($_FILES['image']) && !empty($user_id)) {
    $target_dir = "uploads/";

    if (!file_exists($target_dir)) {
        mkdir($target_dir, 0777, true);
    }

    $file_extension = pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION);
    $new_filename = "profile_" . $user_id . "_" . time() . "." . $file_extension;
    $target_file = $target_dir . $new_filename;

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        $db_path = "uploads/" . $new_filename;
        
        $sql = "UPDATE users SET photo_profile = '$db_path' WHERE id = '$user_id'";
        
        if ($conn->query($sql)) {
            echo json_encode([
                "status" => "success", 
                "message" => "Foto berhasil diupdate",
                "image_url" => $db_path
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Database error"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Gagal upload file"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
}
?>
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include 'koneksi.php';

$name = $_POST['name'] ?? '';
$address = $_POST['address'] ?? '';
$open_time = $_POST['open_time'] ?? '';
$close_time = $_POST['close_time'] ?? '';
$min_price = $_POST['min_price'] ?? '0';
$description = $_POST['description'] ?? 'Fasilitas olahraga';
$sport_type = $_POST['sport_type'] ?? 'General';
$rating = 5.0; 

$image_url = 'assets/images/venue_placeholder.jpg'; 
if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = '../uploads/venues/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }
    
    $fileInfo = pathinfo($_FILES['image']['name']);
    $extension = $fileInfo['extension'];
    $newFileName = 'venue_' . uniqid() . '.' . $extension;
    $targetFile = $uploadDir . $newFileName;
    
    if (move_uploaded_file($_FILES['image']['tmp_name'], $targetFile)) {
        $image_url = 'uploads/venues/' . $newFileName;
    }
}

$stmt = $conn->prepare("INSERT INTO venues (name, address, open_time, close_time, price, description, sport_type, image_url, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("ssssdsssd", $name, $address, $open_time, $close_time, $min_price, $description, $sport_type, $image_url, $rating);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Venue berhasil ditambahkan']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Gagal menambahkan venue']);
}

$stmt->close();
$conn->close();
?>

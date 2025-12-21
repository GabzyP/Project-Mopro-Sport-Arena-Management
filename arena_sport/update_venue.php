<?php
include 'koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $address = $_POST['address'];
    $open_time = $_POST['open_time'];
    $close_time = $_POST['close_time'];
    $min_price = $_POST['min_price'];
    $sport_type = $_POST['sport_type'];
    

    $image_url = null;
    if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
        $target_dir = "../uploads/venues/";
        if (!is_dir($target_dir)) {
            mkdir($target_dir, 0777, true);
        }
        
        $file_name = time() . '_' . basename($_FILES['image']['name']);
        $target_file = $target_dir . $file_name;
        
        if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
            $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http";
            $host = $_SERVER['HTTP_HOST'];
            $image_url = "http://192.168.18.10/arena_sport/uploads/venues/" . $file_name;
        }
    }

    $sql = "UPDATE venues SET name=?, address=?, open_time=?, close_time=?, min_price=?, sport_type=?";
    $params = [$name, $address, $open_time, $close_time, $min_price, $sport_type];
    $types = "ssssss";

    if ($image_url) {
        $sql .= ", image_url=?";
        $params[] = $image_url;
        $types .= "s";
    }

    $sql .= " WHERE id=?";
    $params[] = $id;
    $types .= "i";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param($types, ...$params);

    if ($stmt->execute()) {
        $response['status'] = 'success';
        $response['message'] = 'Venue updated successfully';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Failed to update venue: ' . $stmt->error;
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
?>

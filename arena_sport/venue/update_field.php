<?php
include '../config/koneksi.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $id = $_POST['id'];
    $name = $_POST['name'];
    $sport_type = $_POST['sport_type'];
    $price = $_POST['price'];
    
    $image_url = null;
    if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
        $target_dir = "../uploads/fields/";
        if (!is_dir($target_dir)) {
            mkdir($target_dir, 0777, true);
        }
        
        $file_name = time() . '_' . basename($_FILES['image']['name']);
        $target_file = $target_dir . $file_name;
        
        if (move_uploaded_file($_FILES['image']['tmp_name'], $target_file)) {
            $image_url = "http://192.168.18.10/arena_sport/uploads/fields/" . $file_name;
        }
    }

    $sql = "UPDATE fields SET name=?, sport_type=?, price_per_hour=?";
    $params = [$name, $sport_type, $price];
    $types = "ssd";

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
        $response['message'] = 'Field updated successfully';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Failed to update field: ' . $stmt->error;
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
?>

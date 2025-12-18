<?php
include '../koneksi.php';
header('Content-Type: application/json');

$action = $_GET['action'] ?? '';

if ($action == 'list') {
    $result = $conn->query("SELECT * FROM ads ORDER BY created_at DESC");
    $ads = [];
    while($row = $result->fetch_assoc()) {
        $row['is_active'] = ($row['is_active'] == 1);
        $ads[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $ads]);

} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $type = $_POST['type'] ?? '';

    if ($type == 'add') {
        $title = $_POST['title'];
        $desc = $_POST['desc'];
        $sql = "INSERT INTO ads (title, description) VALUES ('$title', '$desc')";
        if($conn->query($sql)) echo json_encode(["status" => "success"]);

    } elseif ($type == 'toggle') {
        $id = $_POST['id'];
        $status = ($_POST['status'] == 'true') ? 1 : 0;
        $conn->query("UPDATE ads SET is_active = $status WHERE id = $id");
        echo json_encode(["status" => "success"]);

    } elseif ($type == 'delete') {
        $id = $_POST['id'];
        $conn->query("DELETE FROM ads WHERE id = $id");
        echo json_encode(["status" => "success"]);
    }
}
?>
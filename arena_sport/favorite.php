<?php
include 'koneksi.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $action = $_GET['action'] ?? '';
    $user_id = $_GET['user_id'] ?? '';
    $venue_id = $_GET['venue_id'] ?? '';

    if (empty($user_id)) {
        echo json_encode(["status" => "error", "message" => "user_id required"]);
        exit;
    }

    if ($action === 'check') {
        if (empty($venue_id)) {
            echo json_encode(["status" => "error", "message" => "venue_id required"]);
            exit;
        }
        $sql = "SELECT id FROM favorites WHERE user_id = '$user_id' AND venue_id = '$venue_id'";
        $result = $conn->query($sql);
        if ($result && $result->num_rows > 0) {
            echo json_encode(["status" => "success", "is_favorite" => true]);
        } else {
            echo json_encode(["status" => "success", "is_favorite" => false]);
        }
        exit;

    } elseif ($action === 'list') {
        $sql = "SELECT v.* FROM favorites f JOIN venues v ON f.venue_id = v.id WHERE f.user_id = '$user_id' ORDER BY f.created_at DESC";
        $result = $conn->query($sql);
        $venues = [];
        if ($result) {
            while ($row = $result->fetch_assoc()) {
                $venues[] = $row;
            }
        }
        echo json_encode(["status" => "success", "data" => $venues]);
        exit;
    }
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $action = $_POST['action'] ?? '';
    $user_id = $_POST['user_id'] ?? '';
    $venue_id = $_POST['venue_id'] ?? '';

    if ($action === 'toggle') {
        if (empty($user_id) || empty($venue_id)) {
            echo json_encode(["status" => "error", "message" => "user_id and venue_id required"]);
            exit;
        }

        $check = "SELECT id FROM favorites WHERE user_id = '$user_id' AND venue_id = '$venue_id'";
        $result = $conn->query($check);

        if ($result && $result->num_rows > 0) {
            $delete = "DELETE FROM favorites WHERE user_id = '$user_id' AND venue_id = '$venue_id'";
            if ($conn->query($delete) === TRUE) {
                echo json_encode(["status" => "success", "is_favorite" => false, "message" => "Removed from favorites"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Error removing"]);
            }
        } else {
            $insert = "INSERT INTO favorites (user_id, venue_id) VALUES ('$user_id', '$venue_id')";
            if ($conn->query($insert) === TRUE) {
                echo json_encode(["status" => "success", "is_favorite" => true, "message" => "Added to favorites"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Error adding: " . $conn->error]);
            }
        }
        exit;
    }
}

echo json_encode(["status" => "error", "message" => "Invalid action or request"]);
?>

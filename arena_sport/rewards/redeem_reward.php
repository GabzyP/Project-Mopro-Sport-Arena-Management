<?php
include '../config/koneksi.php';
header("Content-Type: application/json");

$conn->query("CREATE TABLE IF NOT EXISTS reward_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reward_title VARCHAR(255) NOT NULL,
    points_cost INT NOT NULL,
    status ENUM('unused', 'used') DEFAULT 'unused',
    redeemed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)");

$user_id = $_POST['user_id'];
$reward_title = $_POST['reward_title'];
$points_cost = $_POST['points_cost'];

if (!$user_id || !$reward_title || !$points_cost) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$sql = "SELECT points FROM users WHERE id = '$user_id'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $current_points = intval($row['points']);

    if ($current_points >= $points_cost) {
        $new_points = $current_points - $points_cost;

        $update = "UPDATE users SET points = '$new_points' WHERE id = '$user_id'";
        if ($conn->query($update)) {
            $history = "INSERT INTO reward_history (user_id, reward_title, points_cost, status) 
                        VALUES ('$user_id', '$reward_title', '$points_cost', 'unused')";
            $conn->query($history);

            echo json_encode([
                "status" => "success", 
                "message" => "Berhasil menukar poin!",
                "new_points" => $new_points
            ]);
        } else {
            echo json_encode(["status" => "error", "message" => "Gagal update poin"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Poin tidak cukup"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User tidak ditemukan"]);
}
?>

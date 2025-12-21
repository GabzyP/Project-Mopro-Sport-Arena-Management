<?php
include '../config/koneksi.php';
header('Content-Type: application/json');

$conn->query("UPDATE users SET points = 0");

$sql = "SELECT user_id, SUM(total_price) as total_spending 
        FROM bookings 
        WHERE status IN ('booked', 'confirmed', 'completed') 
        GROUP BY user_id";

$result = $conn->query($sql);

$updated_count = 0;

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $user_id = $row['user_id'];
        $total_spending = floatval($row['total_spending']);
        
        $points = floor($total_spending / 1000);
        
        if ($points > 0) {
            $updateSql = "UPDATE users SET points = $points WHERE id = '$user_id'";
            if ($conn->query($updateSql)) {
                $updated_count++;
            }
        }
    }
}

echo json_encode([
    "status" => "success", 
    "message" => "Points synced successfully for all users.",
    "users_updated" => $updated_count
]);
?>

<?php
include '../config/koneksi.php';
header('Content-Type: application/json');

$action = $_GET['action'] ?? '';

if ($action == 'list') {
    $search = $_GET['search'] ?? '';
    
    $sql = "SELECT u.id, u.name, u.email, u.status, 
            (SELECT COUNT(*) FROM bookings b WHERE b.user_id = u.id) as booking_count 
            FROM users u 
            WHERE u.role = 'customer'";
            
    if (!empty($search)) {
        $sql .= " AND u.name LIKE '%$search%'";
    }
    
    $result = $conn->query($sql);
    $users = [];
    while($row = $result->fetch_assoc()) {
        $row['is_banned'] = ($row['status'] == 'banned');
        $users[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $users]);

} elseif ($action == 'update_status') {
    $id = $_POST['user_id'];
    $isBanned = $_POST['is_banned']; 
    
    $status = ($isBanned == 'true') ? 'banned' : 'active';
    
    $conn->query("UPDATE users SET status = '$status' WHERE id = '$id'");
    echo json_encode(["status" => "success", "message" => "Status user diupdate"]);
}
?>
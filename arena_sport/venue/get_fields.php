<?php
include '../config/koneksi.php';

$venue_id = isset($_GET['venue_id']) ? $_GET['venue_id'] : '';

if (empty($venue_id)) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT * FROM fields WHERE venue_id = '$venue_id'";
$result = $conn->query($sql);

$fields = array();
while($row = $result->fetch_assoc()) {
    if ($row['facilities'] == null) $row['facilities'] = "";
    $fields[] = $row;
}

echo json_encode($fields);
?>
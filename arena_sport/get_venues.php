<?php
include 'koneksi.php';

$category = isset($_GET['category']) ? $_GET['category'] : 'all';
$search   = isset($_GET['search']) ? $_GET['search'] : '';

$sql = "SELECT * FROM view_venue_details WHERE 1=1";

if ($category != 'all') {
    $sql .= " AND sport_type LIKE '%$category%'";
}

if (!empty($search)) {
    $sql .= " AND (name LIKE '%$search%' OR address LIKE '%$search%')";
}

$result = $conn->query($sql);

$venues = array();
while($row = $result->fetch_assoc()) {
    $venues[] = $row;
}

echo json_encode($venues);
?>
<?php
include 'db_connect.php';

$table = 'reward_history';
$result = $conn->query("DESCRIBE $table");

if ($result) {
    while ($row = $result->fetch_assoc()) {
        echo $row['Field'] . " - " . $row['Type'] . "\n";
    }
} else {
    echo "Error: " . $conn->error;
}
?>

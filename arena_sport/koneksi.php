<?php
$host = 'localhost';
$user = 'root';
$pass = '';
$db   = 'arena_sport'; 

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode([
        "status" => "error", 
        "message" => "Database connection failed: " . $conn->connect_error
    ]));
}

date_default_timezone_set('Asia/Jakarta');
?>
<?php
include 'koneksi.php';

$user_id = $_POST['user_id'];
$name    = $_POST['name'];
$type    = $_POST['type']; 
$balance = $_POST['balance'];
$image   = $_POST['image_url'];

$nameUpper = strtoupper($name);
if (strpos($nameUpper, 'SHOPEE') !== false) $name = 'SHOPEEPAY';
elseif (strpos($nameUpper, 'MANDIRI') !== false) $name = 'MANDIRI';
elseif (strpos($nameUpper, 'BRI') !== false) $name = 'BRI';
elseif (strpos($nameUpper, 'BCA') !== false) $name = 'BCA';
elseif (strpos($nameUpper, 'BNI') !== false) $name = 'BNI';
elseif (strpos($nameUpper, 'GOPAY') !== false) $name = 'GOPAY';
elseif (strpos($nameUpper, 'OVO') !== false) $name = 'OVO';
elseif (strpos($nameUpper, 'DANA') !== false) $name = 'DANA';
elseif (strpos($nameUpper, 'LINKAJA') !== false) $name = 'LINKAJA';
else $name = strtoupper($name); 
    
if (!$user_id || !$name) {
    echo json_encode(["status" => "error", "message" => "Data tidak lengkap"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO payment_methods (user_id, name, type, balance, image_url) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("issss", $user_id, $name, $type, $balance, $image);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Metode berhasil ditambahkan"]);
} else {
    echo json_encode(["status" => "error", "message" => "Gagal: " . $stmt->error]);
}
?>
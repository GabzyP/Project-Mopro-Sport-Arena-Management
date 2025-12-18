-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2025 at 10:20 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `arena_sport`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `booking_code` varchar(50) DEFAULT NULL,
  `field_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `booking_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('locked','booked','confirmed','completed','cancelled') DEFAULT 'booked',
  `total_price` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `cancel_reason` varchar(255) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'Transfer Bank'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `booking_code`, `field_id`, `user_id`, `booking_date`, `start_time`, `end_time`, `status`, `total_price`, `created_at`, `cancel_reason`, `payment_method`) VALUES
(1, 'SA-20251215-0001', 4, 1, '2025-12-15', '06:00:00', '07:00:00', 'cancelled', 204000.00, '2025-12-15 14:52:02', NULL, 'Transfer Bank'),
(2, 'SA-20251215-6111', 1, 1, '2025-12-15', '08:00:00', '09:00:00', 'cancelled', 154000.00, '2025-12-15 15:31:34', NULL, 'Transfer Bank'),
(3, 'SA-20251216-5776', 2, 1, '2025-12-24', '08:00:00', '09:00:00', 'cancelled', 154000.00, '2025-12-16 09:06:38', NULL, 'Transfer Bank'),
(4, 'SA-240701-001', 1, 1, '2024-07-10', '19:00:00', '20:00:00', 'completed', 120000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(5, 'SA-240705-002', 3, 2, '2024-07-15', '16:00:00', '18:00:00', 'completed', 120000.00, '2025-12-17 14:50:38', NULL, 'OVO'),
(6, 'SA-240801-001', 1, 3, '2024-08-02', '18:00:00', '20:00:00', 'completed', 240000.00, '2025-12-17 14:50:38', NULL, 'Transfer Bank'),
(7, 'SA-240805-002', 5, 4, '2024-08-12', '20:00:00', '22:00:00', 'completed', 400000.00, '2025-12-17 14:50:38', NULL, 'DANA'),
(8, 'SA-240810-003', 3, 1, '2024-08-20', '10:00:00', '11:00:00', 'completed', 60000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(9, 'SA-240901-001', 2, 2, '2024-09-05', '19:00:00', '21:00:00', 'completed', 300000.00, '2025-12-17 14:50:38', NULL, 'OVO'),
(10, 'SA-240905-002', 2, 5, '2024-09-12', '20:00:00', '22:00:00', 'completed', 300000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(11, 'SA-240910-003', 1, 1, '2024-09-15', '18:00:00', '19:00:00', 'completed', 120000.00, '2025-12-17 14:50:38', NULL, 'Transfer Bank'),
(12, 'SA-240920-004', 4, 3, '2024-09-20', '15:00:00', '17:00:00', 'cancelled', 120000.00, '2025-12-17 14:50:38', NULL, 'DANA'),
(13, 'SA-241001-001', 5, 4, '2024-10-01', '19:00:00', '21:00:00', 'completed', 400000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(14, 'SA-241005-002', 1, 2, '2024-10-05', '20:00:00', '21:00:00', 'completed', 120000.00, '2025-12-17 14:50:38', NULL, 'OVO'),
(15, 'SA-241010-003', 6, 5, '2024-10-10', '08:00:00', '10:00:00', 'completed', 360000.00, '2025-12-17 14:50:38', NULL, 'Transfer Bank'),
(16, 'SA-241015-004', 3, 1, '2024-10-15', '19:00:00', '20:00:00', 'completed', 60000.00, '2025-12-17 14:50:38', NULL, 'DANA'),
(17, 'SA-241020-005', 2, 2, '2024-10-20', '21:00:00', '23:00:00', 'completed', 300000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(18, 'SA-241101-001', 1, 3, '2024-11-05', '17:00:00', '19:00:00', 'completed', 240000.00, '2025-12-17 14:50:38', NULL, 'OVO'),
(19, 'SA-241110-002', 4, 4, '2024-11-12', '10:00:00', '12:00:00', 'completed', 120000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(20, 'SA-241120-003', 5, 5, '2024-11-25', '16:00:00', '18:00:00', 'confirmed', 400000.00, '2025-12-17 14:50:38', NULL, 'Transfer Bank'),
(21, 'SA-241217-001', 1, 1, '2025-12-17', '19:00:00', '20:00:00', 'booked', 120000.00, '2025-12-17 14:50:38', NULL, 'GoPay'),
(22, 'SA-241217-002', 3, 2, '2025-12-17', '20:00:00', '21:00:00', 'booked', 60000.00, '2025-12-17 14:50:38', NULL, 'OVO'),
(23, 'SA-241218-003', 5, 4, '2025-12-18', '18:00:00', '20:00:00', 'confirmed', 400000.00, '2025-12-17 14:50:38', NULL, 'Transfer Bank'),
(24, 'SA-241219-004', 2, 5, '2025-12-19', '21:00:00', '22:00:00', 'confirmed', 150000.00, '2025-12-17 14:50:38', NULL, 'DANA'),
(25, 'SA-20251218-1465', 1, 1, '2025-12-19', '08:00:00', '09:00:00', 'booked', 150000.00, '2025-12-18 08:42:37', NULL, 'Transfer Bank');

-- --------------------------------------------------------

--
-- Table structure for table `fields`
--

CREATE TABLE `fields` (
  `id` int(11) NOT NULL,
  `venue_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `sport_type` varchar(50) DEFAULT NULL,
  `price_per_hour` decimal(10,2) DEFAULT NULL,
  `facilities` text DEFAULT NULL,
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fields`
--

INSERT INTO `fields` (`id`, `venue_id`, `name`, `sport_type`, `price_per_hour`, `facilities`, `image_url`) VALUES
(1, 1, 'Lapangan Futsal A', 'futsal', 150000.00, 'AC,Locker,Shower', 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6'),
(2, 1, 'Lapangan Futsal B', 'futsal', 150000.00, 'AC,Locker', 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6'),
(3, 1, 'Court Badminton 1', 'badminton', 80000.00, 'AC,Locker', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFaUqXOZ2B9GE4VxE1oU2Ej1bFHoEbplBpVw&s'),
(4, 1, 'Basketball Hall', 'basketball', 200000.00, 'Tribun,Scoreboard', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a'),
(5, 2, 'Vinyl Pitch 1', 'futsal', 120000.00, 'Kantin,WiFi', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018'),
(6, 2, 'Syntethic Pitch 2', 'futsal', 110000.00, 'WiFi', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018'),
(7, 3, 'Tennis Court A', 'tennis', 180000.00, 'Outdoor,Locker', 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0'),
(8, 3, 'Volley Court 1', 'volleyball', 100000.00, 'Indoor', 'https://images.unsplash.com/photo-1612872087720-48ca45b08811'),
(9, 4, 'Court A', 'badminton', 75000.00, 'Parkir Luas', 'https://images.unsplash.com/photo-1626224583764-84786c713cd3'),
(10, 4, 'Court B', 'badminton', 75000.00, 'Parkir Luas', 'https://images.unsplash.com/photo-1626224583764-84786c713cd3'),
(11, 5, 'Main Court', 'basketball', 250000.00, 'Premium Floor,AC', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a'),
(12, NULL, 'Lapangan Futsal A (Vinyl)', 'Futsal', 120000.00, NULL, 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6'),
(13, NULL, 'Lapangan Futsal B (Rumput)', 'Futsal', 150000.00, NULL, 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6'),
(14, NULL, 'Badminton Court 1', 'Badminton', 60000.00, NULL, 'https://images.unsplash.com/photo-1626224583764-847649623d9c'),
(15, NULL, 'Badminton Court 2', 'Badminton', 60000.00, NULL, 'https://images.unsplash.com/photo-1626224583764-847649623d9c'),
(16, NULL, 'Basketball Hall', 'Basketball', 200000.00, NULL, 'https://images.unsplash.com/photo-1546519638-68e109498ee3'),
(17, NULL, 'Tennis Court Premium', 'Tennis', 180000.00, NULL, 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `category` varchar(20) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `category`, `title`, `message`, `is_read`, `created_at`) VALUES
(1, 1, 'system', 'Selamat Datang!', 'Akun Anda berhasil dibuat. Nikmati kemudahan booking lapangan.', 0, '2025-12-17 16:25:38');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `venue_name` varchar(100) DEFAULT NULL,
  `sport_type` varchar(50) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `user_id`, `venue_name`, `sport_type`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 'Lapangan Futsal Galaxy', 'Futsal', 5, 'Rumput sintetisnya mantap, ga licin.', '2025-12-17 23:49:13'),
(2, 1, 'GOR Badminton Sentral', 'Badminton', 4, 'Lampu terang, tapi agak panas.', '2025-12-17 23:49:13');

-- --------------------------------------------------------

--
-- Table structure for table `saved_payment_methods`
--

CREATE TABLE `saved_payment_methods` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `detail` varchar(100) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','customer') DEFAULT 'customer',
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','banned') DEFAULT 'active',
  `photo_profile` varchar(255) DEFAULT NULL,
  `points` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `phone`, `created_at`, `status`, `photo_profile`, `points`) VALUES
(1, 'Admin Sport', 'admin@arena.com', '$2a$12$mrtvQanLmP6TP.YPnLh7e.TUF8mVcFQTINGQpeu4LdlIxBlPf6cUS', 'admin', NULL, '2025-12-15 10:22:57', 'active', NULL, 1550),
(2, 'Ahmad Fulan', 'fulan@arena.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer', NULL, '2025-12-15 10:22:57', 'active', NULL, 0),
(3, '1', '1', '$2y$10$KpANdqucmtHz1.EByVR3nu.1.YYgvUMY7hRoBe.2UZIIBp1ebEu.C', 'customer', NULL, '2025-12-15 10:23:36', 'active', 'uploads/profile_3_1766047325.jpg', 0),
(5, 'Ahmad Rizki', 'ahmad@email.com', '$2y$10$dummyhash', 'customer', '081234567890', '2025-12-17 14:50:38', 'active', NULL, 0),
(6, 'Budi Santoso', 'budi@email.com', '$2y$10$dummyhash', 'customer', '081298765432', '2025-12-17 14:50:38', 'active', NULL, 0),
(7, 'Citra Dewi', 'citra@email.com', '$2y$10$dummyhash', 'customer', '081345678901', '2025-12-17 14:50:38', 'banned', NULL, 0),
(8, 'Dani Pratama', 'dani@email.com', '$2y$10$dummyhash', 'customer', '081456789012', '2025-12-17 14:50:38', 'active', NULL, 0),
(9, 'Eka Putri', 'eka@email.com', '$2y$10$dummyhash', 'customer', '081567890123', '2025-12-17 14:50:38', 'active', NULL, 0),
(10, '', '', '$2y$10$WsyI7ZNKWS84J38TVxKOfu37SnRu0L/UxJYJzZy1m391aJi7m9FeG', 'customer', '', '2025-12-18 08:52:48', 'active', NULL, 0),
(11, 'Gabriel Glenn Peter Pardede', 'gabzy@gmail.com', '$2y$10$tVznjmO0B210pHdDx.HbjeaSr8ALUQg8pg1AwHjKMFIS1msVOsUw2', 'customer', '08311877712', '2025-12-18 09:00:10', 'active', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `venues`
--

CREATE TABLE `venues` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venues`
--

INSERT INTO `venues` (`id`, `name`, `address`, `image_url`, `open_time`, `close_time`, `rating`) VALUES
(1, 'Arena Sport Center', 'Jl. Sudirman No. 123, Jakarta Selatan', 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8', '06:00:00', '23:00:00', 4.8),
(2, 'Galaxy Futsal Arena', 'Jl. Tebet Raya No. 45, Jakarta Selatan', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018', '08:00:00', '23:00:00', 4.6),
(3, 'Champion Sports Hub', 'Jl. Gatot Subroto No. 88, Jakarta Pusat', 'https://images.unsplash.com/photo-1626224583764-84786c713cd3', '07:00:00', '22:00:00', 4.9),
(4, 'Bugar Badminton Hall', 'Jl. Panjang No. 12, Jakarta Barat', 'https://plus.unsplash.com/premium_photo-1678743681408-7243cb3b5668', '08:00:00', '22:00:00', 4.5),
(5, 'Pro Basket Court', 'Jl. Kemang Raya, Jakarta Selatan', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a', '09:00:00', '22:00:00', 4.7);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_venue_details`
-- (See below for the actual view)
--
CREATE TABLE `view_venue_details` (
`id` int(11)
,`name` varchar(100)
,`address` text
,`image_url` text
,`rating` decimal(2,1)
,`open_time` time
,`close_time` time
,`sport_type` mediumtext
,`min_price` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_venue_details`
--
DROP TABLE IF EXISTS `view_venue_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_venue_details`  AS SELECT `v`.`id` AS `id`, `v`.`name` AS `name`, `v`.`address` AS `address`, `v`.`image_url` AS `image_url`, `v`.`rating` AS `rating`, `v`.`open_time` AS `open_time`, `v`.`close_time` AS `close_time`, group_concat(distinct `f`.`sport_type` separator ',') AS `sport_type`, min(`f`.`price_per_hour`) AS `min_price` FROM (`venues` `v` left join `fields` `f` on(`v`.`id` = `f`.`venue_id`)) GROUP BY `v`.`id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `field_id` (`field_id`);

--
-- Indexes for table `fields`
--
ALTER TABLE `fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venue_id` (`venue_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `saved_payment_methods`
--
ALTER TABLE `saved_payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `venues`
--
ALTER TABLE `venues`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `fields`
--
ALTER TABLE `fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `saved_payment_methods`
--
ALTER TABLE `saved_payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `venues`
--
ALTER TABLE `venues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`);

--
-- Constraints for table `fields`
--
ALTER TABLE `fields`
  ADD CONSTRAINT `fields_ibfk_1` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `saved_payment_methods`
--
ALTER TABLE `saved_payment_methods`
  ADD CONSTRAINT `saved_payment_methods_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

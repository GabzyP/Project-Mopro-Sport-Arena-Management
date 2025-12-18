-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2025 at 11:31 PM
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
-- Table structure for table `admin_settings`
--

CREATE TABLE `admin_settings` (
  `id` int(11) NOT NULL,
  `push_notif` tinyint(1) DEFAULT 1,
  `auto_confirm` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_settings`
--

INSERT INTO `admin_settings` (`id`, `push_notif`, `auto_confirm`) VALUES
(1, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ads`
--

CREATE TABLE `ads` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `views` int(11) DEFAULT 0,
  `clicks` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ads`
--

INSERT INTO `ads` (`id`, `title`, `description`, `image_url`, `is_active`, `views`, `clicks`, `created_at`) VALUES
(1, 'Promo Member Baru', 'Dapatkan diskon 50% untuk booking pertama!', 'promo_new.jpg', 1, 1500, 120, '2025-12-18 15:27:48'),
(2, 'Flash Sale 12.12', 'Diskon kilat semua lapangan jam 12-14', 'promo_1212.jpg', 1, 2300, 450, '2025-12-18 15:27:48'),
(3, 'Paket Hemat Weekend', 'Booking 2 jam gratis air mineral', 'promo_weekend.jpg', 0, 800, 30, '2025-12-18 15:27:48'),
(4, 'Turnamen Futsal Cup', 'Daftarkan tim kamu sekarang!', 'promo_cup.jpg', 1, 5000, 890, '2025-12-18 15:27:48'),
(5, 'Diskon Pelajar', 'Tunjukkan kartu pelajar, dapat diskon 20%', 'promo_student.jpg', 1, 600, 25, '2025-12-18 15:27:48');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `booking_code` varchar(50) DEFAULT NULL,
  `booking_group_id` varchar(50) DEFAULT NULL,
  `field_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `booking_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('locked','booked','confirmed','completed','cancelled') DEFAULT 'booked',
  `total_price` decimal(10,2) DEFAULT 0.00,
  `payment_token` varchar(255) DEFAULT NULL,
  `payment_url` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `cancel_reason` varchar(255) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'Transfer Bank',
  `locked_at` datetime DEFAULT NULL COMMENT 'Waktu user mulai klik slot',
  `locked_expires_at` datetime DEFAULT NULL COMMENT 'Batas waktu lock (3 menit)',
  `payment_proof` varchar(255) DEFAULT NULL COMMENT 'Bukti bayar',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `booking_code`, `booking_group_id`, `field_id`, `user_id`, `booking_date`, `start_time`, `end_time`, `status`, `total_price`, `payment_token`, `payment_url`, `created_at`, `cancel_reason`, `payment_method`, `locked_at`, `locked_expires_at`, `payment_proof`, `updated_at`) VALUES
(1, 'SA-241218-001', NULL, 1, 2, '2025-12-18', '19:00:00', '20:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(2, 'SA-241218-002', NULL, 4, 3, '2025-12-18', '20:00:00', '22:00:00', 'confirmed', 100000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(3, 'SA-241218-003', NULL, 6, 4, '2025-12-18', '16:00:00', '18:00:00', 'booked', 400000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(4, 'SA-241218-004', NULL, 2, 5, '2025-12-18', '10:00:00', '12:00:00', 'confirmed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(5, 'SA-WEEK-001', NULL, 2, 6, '2025-12-16', '18:00:00', '19:00:00', 'completed', 100000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(6, 'SA-WEEK-002', NULL, 1, 7, '2025-12-15', '20:00:00', '22:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(7, 'SA-WEEK-003', NULL, 9, 8, '2025-12-17', '08:00:00', '10:00:00', 'cancelled', 900000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(8, 'SA-WEEK-004', NULL, 3, 9, '2025-12-14', '19:00:00', '21:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(9, 'SA-WEEK-005', NULL, 5, 10, '2025-12-13', '15:00:00', '17:00:00', 'completed', 90000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(10, 'SA-MTH-001', NULL, 7, 11, '2025-12-08', '10:00:00', '12:00:00', 'completed', 700000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(11, 'SA-MTH-002', NULL, 3, 12, '2025-12-06', '19:00:00', '20:00:00', 'completed', 110000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(12, 'SA-MTH-003', NULL, 5, 13, '2025-12-03', '15:00:00', '16:00:00', 'completed', 45000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(13, 'SA-MTH-004', NULL, 1, 14, '2025-11-28', '21:00:00', '23:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(14, 'SA-MTH-005', NULL, 8, 15, '2025-11-26', '09:00:00', '11:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(15, 'SA-MTH-006', NULL, 2, 16, '2025-11-23', '18:00:00', '20:00:00', 'completed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(16, 'SA-LAST-001', NULL, 4, 17, '2025-11-13', '16:00:00', '17:00:00', 'completed', 50000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(17, 'SA-LAST-002', NULL, 6, 18, '2025-11-10', '19:00:00', '21:00:00', 'completed', 400000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(18, 'SA-LAST-003', NULL, 9, 19, '2025-11-08', '08:00:00', '10:00:00', 'completed', 900000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(19, 'SA-LAST-004', NULL, 1, 20, '2025-11-03', '20:00:00', '22:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(20, 'SA-LAST-005', NULL, 3, 21, '2025-10-29', '14:00:00', '16:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(21, 'SA-OLD-001', NULL, 2, 22, '2025-10-09', '18:00:00', '20:00:00', 'completed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(22, 'SA-OLD-002', NULL, 5, 23, '2025-10-04', '10:00:00', '11:00:00', 'completed', 45000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(23, 'SA-OLD-003', NULL, 7, 24, '2025-09-29', '20:00:00', '22:00:00', 'completed', 360000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(24, 'SA-OLD-004', NULL, 8, 25, '2025-09-19', '15:00:00', '17:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-18 16:05:26'),
(25, 'SA-20251219-6356', NULL, 1, 1, '2025-12-19', '21:00:00', '22:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 17:49:07', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 17:49:07'),
(26, 'SA-20251219-8919', NULL, 1, 1, '2025-12-19', '08:00:00', '09:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 21:43:41', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-18 21:43:41'),
(27, 'SA-20251219-9777', NULL, 1, 32, '2025-12-19', '09:00:00', '10:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 22:07:13', NULL, 'dana', NULL, NULL, NULL, '2025-12-18 22:07:13');

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
(1, 1, 'Lapangan A (Rumput Sintetis)', 'Futsal', 120000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(2, 1, 'Lapangan B (Vinyl)', 'Futsal', 100000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(3, 1, 'Lapangan C (Interlock)', 'Futsal', 110000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(4, 2, 'Court 1 (Karpet Standar)', 'Badminton', 50000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800&auto=format&fit=crop'),
(5, 2, 'Court 2 (Lantai Kayu)', 'Badminton', 45000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800&auto=format&fit=crop'),
(6, 2, 'Main Hall Basket', 'Basketball', 200000.00, NULL, 'https://images.unsplash.com/photo-1546519638-68e109498ee3'),
(7, 3, 'Kolam Renang Olympic', 'Swimming', 50000.00, NULL, 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7'),
(8, 3, 'Tennis Court A', 'Tennis', 150000.00, NULL, 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0'),
(9, 6, 'Indoor Court A', 'Basketball', 350000.00, NULL, 'https://images.unsplash.com/photo-1504450758481-7338eba7524a'),
(10, 6, 'Outdoor Court B', 'Basketball', 150000.00, NULL, 'https://images.unsplash.com/photo-1519861531473-9200262188bf'),
(11, 7, 'VIP Futsal 1', 'Futsal', 180000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(12, 7, 'VIP Futsal 2', 'Futsal', 180000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(13, 7, 'Regular Futsal', 'Futsal', 130000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(14, 11, 'Mini Soccer 1', 'Mini Soccer', 450000.00, NULL, 'https://images.unsplash.com/photo-1551958219-acbc608c6377'),
(15, 11, 'Mini Soccer 2', 'Mini Soccer', 450000.00, NULL, 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d'),
(16, 4, 'Lapangan Utama Setia Budi Court', 'Tennis, Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(17, 5, 'Lapangan Utama Tuntungan Futsal', 'Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(18, 8, 'Lapangan Utama Kelapa Gading Badminton', 'Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800&auto=format&fit=crop'),
(19, 9, 'Lapangan Utama GBK Tennis Outdoor', 'Tennis', 85000.00, NULL, 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?q=80&w=800&auto=format&fit=crop'),
(20, 10, 'Lapangan Utama Kebon Jeruk Sport', 'Futsal, Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(21, 12, 'Lapangan Utama Dago Atas Gym & Sport', 'Gym, Basketball', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(22, 13, 'Lapangan Utama Gor C-Tra Arena', 'Basketball', 85000.00, NULL, 'https://images.unsplash.com/photo-1546519638-68e109498ee2?q=80&w=800&auto=format&fit=crop'),
(23, 14, 'Lapangan Utama Surabaya Sport Center', 'Badminton, Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(24, 15, 'Lapangan Utama Graha Futsal Family', 'Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop');

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

-- --------------------------------------------------------

--
-- Table structure for table `promo_codes`
--

CREATE TABLE `promo_codes` (
  `id` int(11) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `usage_limit` int(11) DEFAULT 100,
  `used_count` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 2, 'Galaxy Futsal Arena', 'Futsal', 5, 'Rumputnya bagus banget, sepatu jadi enak dipake.', '2025-12-18 22:27:48'),
(2, 3, 'Gor Angsapura', 'Badminton', 4, 'Lapangan oke, tapi agak panas dikit AC-nya.', '2025-12-18 22:27:48'),
(3, 5, 'Cilandak Town Futsal', 'Futsal', 5, 'Lokasi strategis, fasilitas lengkap ada shower air panas.', '2025-12-18 22:27:48'),
(4, 6, 'Senayan Basket Hall', 'Basketball', 5, 'Lantai kayunya standar internasional, mantap!', '2025-12-18 22:27:48'),
(5, 10, 'Siliwangi Soccer Field', 'Mini Soccer', 5, 'Best mini soccer in Bandung!', '2025-12-18 22:27:48'),
(6, 12, 'Dago Atas Gym', 'Gym', 4, 'Alat lengkap, view nya bagus.', '2025-12-18 22:27:48');

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
(2, 'Raffi Ahmad', 'raffi@email.com', '$2y$10$dummyhash', 'customer', '08123456001', '2025-12-18 15:27:48', 'active', NULL, 5000),
(3, 'Nagita Slavina', 'gigi@email.com', '$2y$10$dummyhash', 'customer', '08123456002', '2025-12-18 15:27:48', 'active', NULL, 4500),
(4, 'Deddy Corbuzier', 'deddy@email.com', '$2y$10$dummyhash', 'customer', '08123456003', '2025-12-18 15:27:48', 'active', NULL, 2100),
(5, 'Jerome Polin', 'jerome@email.com', '$2y$10$dummyhash', 'customer', '08123456004', '2025-12-18 15:27:48', 'active', NULL, 1200),
(6, 'Maudy Ayunda', 'maudy@email.com', '$2y$10$dummyhash', 'customer', '08123456005', '2025-12-18 15:27:48', 'active', NULL, 3000),
(7, 'Reza Rahadian', 'reza@email.com', '$2y$10$dummyhash', 'customer', '08123456006', '2025-12-18 15:27:48', 'active', NULL, 800),
(8, 'Anya Geraldine', 'anya@email.com', '$2y$10$dummyhash', 'customer', '08123456007', '2025-12-18 15:27:48', 'active', NULL, 150),
(9, 'Fadly Faisal', 'fadly@email.com', '$2y$10$dummyhash', 'customer', '08123456008', '2025-12-18 15:27:48', 'active', NULL, 450),
(10, 'Fuji An', 'fuji@email.com', '$2y$10$dummyhash', 'customer', '08123456009', '2025-12-18 15:27:48', 'active', NULL, 600),
(11, 'Thariq Halilintar', 'thariq@email.com', '$2y$10$dummyhash', 'customer', '08123456010', '2025-12-18 15:27:48', 'active', NULL, 900),
(12, 'Atta Halilintar', 'atta@email.com', '$2y$10$dummyhash', 'customer', '08123456011', '2025-12-18 15:27:48', 'active', NULL, 3500),
(13, 'Aurel Hermansyah', 'aurel@email.com', '$2y$10$dummyhash', 'customer', '08123456012', '2025-12-18 15:27:48', 'active', NULL, 2000),
(14, 'Lyodra Ginting', 'lyodra@email.com', '$2y$10$dummyhash', 'customer', '08123456013', '2025-12-18 15:27:48', 'active', NULL, 750),
(15, 'Mahalini Raharja', 'mahalini@email.com', '$2y$10$dummyhash', 'customer', '08123456014', '2025-12-18 15:27:48', 'active', NULL, 600),
(16, 'Rizky Febian', 'rizky@email.com', '$2y$10$dummyhash', 'customer', '08123456015', '2025-12-18 15:27:48', 'active', NULL, 1100),
(17, 'Tiara Andini', 'tiara@email.com', '$2y$10$dummyhash', 'customer', '08123456016', '2025-12-18 15:27:48', 'banned', NULL, 0),
(18, 'Jefri Nichol', 'jefri@email.com', '$2y$10$dummyhash', 'customer', '08123456017', '2025-12-18 15:27:48', 'active', NULL, 90),
(19, 'Iqbaal Ramadhan', 'iqbaal@email.com', '$2y$10$dummyhash', 'customer', '08123456018', '2025-12-18 15:27:48', 'active', NULL, 4500),
(20, 'Angga Yunanda', 'angga@email.com', '$2y$10$dummyhash', 'customer', '08123456019', '2025-12-18 15:27:48', 'active', NULL, 1200),
(21, 'Shenina Cinnamon', 'shenina@email.com', '$2y$10$dummyhash', 'customer', '08123456020', '2025-12-18 15:27:48', 'active', NULL, 350),
(22, 'Chicco Jerikho', 'chicco@email.com', '$2y$10$dummyhash', 'customer', '08123456021', '2025-12-18 15:27:48', 'active', NULL, 500),
(23, 'Putri Marino', 'putri@email.com', '$2y$10$dummyhash', 'customer', '08123456022', '2025-12-18 15:27:48', 'active', NULL, 400),
(24, 'Rio Dewanto', 'rio@email.com', '$2y$10$dummyhash', 'customer', '08123456023', '2025-12-18 15:27:48', 'active', NULL, 650),
(25, 'Atiqah Hasiholan', 'atiqah@email.com', '$2y$10$dummyhash', 'customer', '08123456024', '2025-12-18 15:27:48', 'active', NULL, 300),
(26, 'Vino G Bastian', 'vino@email.com', '$2y$10$dummyhash', 'customer', '08123456025', '2025-12-18 15:27:48', 'active', NULL, 800),
(27, 'Marsha Timothy', 'marsha@email.com', '$2y$10$dummyhash', 'customer', '08123456026', '2025-12-18 15:27:48', 'active', NULL, 700),
(28, 'Adipati Dolken', 'adipati@email.com', '$2y$10$dummyhash', 'customer', '08123456027', '2025-12-18 15:27:48', 'active', NULL, 200),
(29, 'Vanesha Prescilla', 'sasha@email.com', '$2y$10$dummyhash', 'customer', '08123456028', '2025-12-18 15:27:48', 'active', NULL, 250),
(30, 'Bryan Domani', 'bryan@email.com', '$2y$10$dummyhash', 'customer', '08123456029', '2025-12-18 15:27:48', 'active', NULL, 350),
(31, 'Megan Domani', 'megan@email.com', '$2y$10$dummyhash', 'customer', '08123456030', '2025-12-18 15:27:48', 'active', NULL, 450),
(32, 'Gabriel Pardede', 'gabzy@gmail.com', '$2y$10$yDSd8Y8oj2UKUYvhMvKwcOjBMYqnuraJ2hpN7Tlc6rKoV5gFCtCqq', 'customer', '08311877712', '2025-12-18 16:14:06', 'active', 'uploads/profile_32_1766089314.jpg', 0),
(33, 'Gabriel Pardede', 'gabzygl@gmail.com', '$2y$10$nKf2KgWBPuhcqIntrHIeieFc1Qu.Y4AZoFHM6B2F.WyPnffVLlN4i', 'customer', '08311877712', '2025-12-18 17:32:44', 'active', NULL, 0);

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
  `rating` decimal(2,1) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `sport_type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `venues`
--

INSERT INTO `venues` (`id`, `name`, `address`, `image_url`, `open_time`, `close_time`, `rating`, `latitude`, `longitude`, `city`, `sport_type`) VALUES
(1, 'Galaxy Futsal Arena', 'Jl. Dr. Mansyur No. 88, Medan Baru', 'https://images.unsplash.com/photo-1552667466-07770ae110d0?q=80&w=800&auto=format&fit=crop', NULL, NULL, 4.8, 3.5689, 98.6543, 'Medan', 'Futsal'),
(2, 'Gor Angsapura', 'Jl. Logam No. 12, Medan Area', 'https://static.wixstatic.com/media/131e07_39dcb25553514393b85f178c531325c7~mv2.jpg/v1/fill/w_800,h_600,al_c,q_85/131e07_39dcb25553514393b85f178c531325c7~mv2.jpg', NULL, NULL, 4.5, 3.5852, 98.6756, 'Medan', 'Badminton, Basketball'),
(3, 'Cemara Sport Center', 'Komp. Cemara Asri, Percut Sei Tuan', 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7', NULL, NULL, 4.7, 3.6367, 98.7042, 'Medan', 'Swimming, Tennis'),
(4, 'Setia Budi Court', 'Jl. Setia Budi No. 45, Medan Sunggal', 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0', NULL, NULL, 4.6, 3.5789, 98.6321, 'Medan', 'Tennis, Badminton'),
(5, 'Tuntungan Futsal', 'Jl. Jamin Ginting Km 12', 'https://images.unsplash.com/photo-1552667466-07770ae110d0?q=80&w=800&auto=format&fit=crop', NULL, NULL, 4.2, 3.5112, 98.6123, 'Medan', 'Futsal'),
(6, 'Senayan Basket Hall', 'Gelora Bung Karno, Jakarta Pusat', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?q=80&w=800&auto=format&fit=crop', NULL, NULL, 4.9, -6.2183, 106.8026, 'Jakarta', 'Basketball'),
(7, 'Cilandak Town Futsal', 'Citos, Jakarta Selatan', 'https://images.unsplash.com/photo-1552667466-07770ae110d0?q=80&w=800&auto=format&fit=crop', NULL, NULL, 4.4, -6.2912, 106.8011, 'Jakarta', 'Futsal'),
(8, 'Kelapa Gading Badminton', 'Jl. Boulevard Raya, Jakarta Utara', 'https://asset.ayo.co.id/image/venue/173201071917732.image_cropper_1732010692059_large.jpg', NULL, NULL, 4.3, -6.1592, 106.9065, 'Jakarta', 'Badminton'),
(9, 'GBK Tennis Outdoor', 'Jl. Pintu Satu Senayan, Jakarta Pusat', 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6', NULL, NULL, 4.8, -6.2145, 106.8001, 'Jakarta', 'Tennis'),
(10, 'Kebon Jeruk Sport', 'Jl. Panjang No. 5, Jakarta Barat', 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8', NULL, NULL, 4.5, -6.1923, 106.7721, 'Jakarta', 'Futsal, Badminton'),
(11, 'Siliwangi Soccer Field', 'Jl. Lombok, Bandung Wetan', 'https://images.unsplash.com/photo-1551958219-acbc608c6377', NULL, NULL, 4.7, -6.9098, 107.6163, 'Bandung', 'Mini Soccer, Futsal'),
(12, 'Dago Atas Gym & Sport', 'Jl. Dago Pakar, Coblong', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48', NULL, NULL, 4.5, -6.8845, 107.6136, 'Bandung', 'Gym, Basketball'),
(13, 'Gor C-Tra Arena', 'Jl. Cikutra, Bandung', 'https://images.unsplash.com/photo-1505666287802-931dc83948e9', NULL, NULL, 4.6, -6.9034, 107.6432, 'Bandung', 'Basketball'),
(14, 'Surabaya Sport Center', 'Jl. Kertajaya, Gubeng', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b', NULL, NULL, 4.6, -7.2798, 112.7689, 'Surabaya', 'Badminton, Futsal'),
(15, 'Graha Futsal Family', 'Jl. Mayjen Sungkono, Dukuh Pakis', 'https://images.unsplash.com/photo-1552667466-07770ae110d0?q=80&w=800&auto=format&fit=crop', NULL, NULL, 4.2, -7.2912, 112.7231, 'Surabaya', 'Futsal');

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
,`open_time` time
,`close_time` time
,`rating` decimal(2,1)
,`latitude` double
,`longitude` double
,`city` varchar(50)
,`sport_type` varchar(255)
,`total_fields` bigint(21)
,`min_price` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_venue_details`
--
DROP TABLE IF EXISTS `view_venue_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_venue_details`  AS SELECT `v`.`id` AS `id`, `v`.`name` AS `name`, `v`.`address` AS `address`, `v`.`image_url` AS `image_url`, `v`.`open_time` AS `open_time`, `v`.`close_time` AS `close_time`, `v`.`rating` AS `rating`, `v`.`latitude` AS `latitude`, `v`.`longitude` AS `longitude`, `v`.`city` AS `city`, `v`.`sport_type` AS `sport_type`, (select count(0) from `fields` `f` where `f`.`venue_id` = `v`.`id`) AS `total_fields`, (select min(`f`.`price_per_hour`) from `fields` `f` where `f`.`venue_id` = `v`.`id`) AS `min_price` FROM `venues` AS `v` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_settings`
--
ALTER TABLE `admin_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ads`
--
ALTER TABLE `ads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `field_id` (`field_id`),
  ADD KEY `idx_booking_date_field` (`booking_date`,`field_id`),
  ADD KEY `idx_booking_status` (`status`);

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
-- Indexes for table `promo_codes`
--
ALTER TABLE `promo_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

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
-- AUTO_INCREMENT for table `ads`
--
ALTER TABLE `ads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `fields`
--
ALTER TABLE `fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promo_codes`
--
ALTER TABLE `promo_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `saved_payment_methods`
--
ALTER TABLE `saved_payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `venues`
--
ALTER TABLE `venues`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 19, 2025 at 03:07 AM
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
  `venue_id` int(11) DEFAULT NULL,
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

INSERT INTO `bookings` (`id`, `booking_code`, `booking_group_id`, `field_id`, `user_id`, `venue_id`, `booking_date`, `start_time`, `end_time`, `status`, `total_price`, `payment_token`, `payment_url`, `created_at`, `cancel_reason`, `payment_method`, `locked_at`, `locked_expires_at`, `payment_proof`, `updated_at`) VALUES
(1, 'SA-241218-001', NULL, 1, 2, 1, '2025-12-18', '19:00:00', '20:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(2, 'SA-241218-002', NULL, 4, 3, 2, '2025-12-18', '20:00:00', '22:00:00', 'confirmed', 100000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(3, 'SA-241218-003', NULL, 6, 4, 2, '2025-12-18', '16:00:00', '18:00:00', 'booked', 400000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(4, 'SA-241218-004', NULL, 2, 5, 1, '2025-12-18', '10:00:00', '12:00:00', 'confirmed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(5, 'SA-WEEK-001', NULL, 2, 6, 1, '2025-12-16', '18:00:00', '19:00:00', 'completed', 100000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(6, 'SA-WEEK-002', NULL, 1, 7, 1, '2025-12-15', '20:00:00', '22:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(7, 'SA-WEEK-003', NULL, 9, 8, 6, '2025-12-17', '08:00:00', '10:00:00', 'cancelled', 900000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(8, 'SA-WEEK-004', NULL, 3, 9, 1, '2025-12-14', '19:00:00', '21:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(9, 'SA-WEEK-005', NULL, 5, 10, 2, '2025-12-13', '15:00:00', '17:00:00', 'completed', 90000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(10, 'SA-MTH-001', NULL, 7, 11, 3, '2025-12-08', '10:00:00', '12:00:00', 'completed', 700000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(11, 'SA-MTH-002', NULL, 3, 12, 1, '2025-12-06', '19:00:00', '20:00:00', 'completed', 110000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(12, 'SA-MTH-003', NULL, 5, 13, 2, '2025-12-03', '15:00:00', '16:00:00', 'completed', 45000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(13, 'SA-MTH-004', NULL, 1, 14, 1, '2025-11-28', '21:00:00', '23:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(14, 'SA-MTH-005', NULL, 8, 15, 3, '2025-11-26', '09:00:00', '11:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(15, 'SA-MTH-006', NULL, 2, 16, 1, '2025-11-23', '18:00:00', '20:00:00', 'completed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(16, 'SA-LAST-001', NULL, 4, 17, 2, '2025-11-13', '16:00:00', '17:00:00', 'completed', 50000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(17, 'SA-LAST-002', NULL, 6, 18, 2, '2025-11-10', '19:00:00', '21:00:00', 'completed', 400000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(18, 'SA-LAST-003', NULL, 9, 19, 6, '2025-11-08', '08:00:00', '10:00:00', 'completed', 900000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(19, 'SA-LAST-004', NULL, 1, 20, 1, '2025-11-03', '20:00:00', '22:00:00', 'completed', 240000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(20, 'SA-LAST-005', NULL, 3, 21, 1, '2025-10-29', '14:00:00', '16:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(21, 'SA-OLD-001', NULL, 2, 22, 1, '2025-10-09', '18:00:00', '20:00:00', 'completed', 200000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(22, 'SA-OLD-002', NULL, 5, 23, 2, '2025-10-04', '10:00:00', '11:00:00', 'completed', 45000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'Cash', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(23, 'SA-OLD-003', NULL, 7, 24, 3, '2025-09-29', '20:00:00', '22:00:00', 'completed', 360000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'OVO', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(24, 'SA-OLD-004', NULL, 8, 25, 3, '2025-09-19', '15:00:00', '17:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-18 15:27:48', NULL, 'DANA', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(25, 'SA-20251219-6356', NULL, 1, 1, 1, '2025-12-19', '21:00:00', '22:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 17:49:07', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(26, 'SA-20251219-8919', NULL, 1, 1, 1, '2025-12-19', '08:00:00', '09:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 21:43:41', NULL, 'Transfer Bank', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(27, 'SA-20251219-9777', NULL, 1, 32, 1, '2025-12-19', '09:00:00', '10:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 22:07:13', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(28, 'SA-20251219-2344', NULL, 1, 32, 1, '2025-12-19', '12:00:00', '13:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 22:43:51', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(29, 'SA-20251219-3992', NULL, 19, 34, 9, '2025-12-19', '17:00:00', '18:00:00', 'booked', 85000.00, NULL, NULL, '2025-12-18 23:11:15', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(30, 'SA-20251219-5027', NULL, 1, 34, 1, '2025-12-19', '10:00:00', '11:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-18 23:23:35', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(31, 'SA-20251219-5812', NULL, 3, 34, 1, '2025-12-19', '12:00:00', '13:00:00', 'booked', 110000.00, NULL, NULL, '2025-12-18 23:26:51', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(32, 'SA-20251219-1445', NULL, 3, 34, 1, '2025-12-19', '14:00:00', '15:00:00', 'booked', 110000.00, NULL, NULL, '2025-12-18 23:30:03', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(33, 'SA-20251219-1011', NULL, 1, 32, 1, '2025-12-19', '11:00:00', '12:00:00', 'booked', 124000.00, NULL, NULL, '2025-12-19 00:24:59', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(34, 'BK-32001', NULL, 1, 32, 1, '2025-12-19', '19:00:00', '21:00:00', 'booked', 240000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(35, 'BK-32002', NULL, 4, 32, 2, '2025-12-20', '08:00:00', '09:00:00', 'confirmed', 60000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(36, 'BK-32003', NULL, 9, 32, 6, '2025-12-17', '20:00:00', '22:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(37, 'BK-32004', NULL, 14, 32, 11, '2025-12-14', '16:00:00', '17:00:00', 'completed', 110000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(38, 'BK-32005', NULL, 2, 32, 1, '2025-12-12', '18:00:00', '19:00:00', 'cancelled', 120000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(39, 'BK-32006', NULL, 11, 32, 7, '2025-12-09', '21:00:00', '22:00:00', 'completed', 120000.00, NULL, NULL, '2025-12-19 00:53:00', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(40, 'BK-77123', NULL, 1, 32, 1, '2025-12-20', '19:00:00', '21:00:00', 'booked', 150000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(41, 'BK-77124', NULL, 4, 32, 2, '2025-12-18', '08:00:00', '09:00:00', 'completed', 60000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(42, 'BK-77125', NULL, 6, 32, 2, '2025-12-15', '20:00:00', '22:00:00', 'completed', 200000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(43, 'BK-77126', NULL, 2, 32, 1, '2025-12-10', '16:00:00', '17:00:00', 'cancelled', 85000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(44, 'BK-77127', NULL, 11, 32, 7, '2025-12-05', '18:00:00', '20:00:00', 'completed', 300000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(45, 'BK-77128', NULL, 9, 32, 6, '2025-12-01', '21:00:00', '22:00:00', 'completed', 120000.00, NULL, NULL, '2025-12-19 01:00:22', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(46, 'BK-9901', NULL, 1, 32, 1, '2025-12-20', '19:00:00', '21:00:00', 'booked', 170000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(47, 'BK-9902', NULL, 4, 32, 2, '2025-12-18', '08:00:00', '09:00:00', 'completed', 60000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(48, 'BK-9903', NULL, 6, 32, 2, '2025-12-15', '20:00:00', '22:00:00', 'completed', 160000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(49, 'BK-9904', NULL, 9, 32, 6, '2025-12-10', '16:00:00', '17:00:00', 'cancelled', 85000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(50, 'BK-9905', NULL, 14, 32, 11, '2025-12-05', '18:00:00', '20:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(51, 'BK-9906', NULL, 11, 32, 7, '2025-12-01', '21:00:00', '22:00:00', 'completed', 120000.00, NULL, NULL, '2025-12-19 01:01:25', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:03:31'),
(52, 'BK-32001', NULL, 1, 32, 1, '2025-12-20', '19:00:00', '21:00:00', 'booked', 170000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(53, 'BK-32002', NULL, 4, 32, 2, '2025-12-18', '08:00:00', '09:00:00', 'completed', 60000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(54, 'BK-32003', NULL, 6, 32, 6, '2025-12-15', '20:00:00', '22:00:00', 'completed', 160000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'ovo', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(55, 'BK-32004', NULL, 9, 32, 9, '2025-12-10', '16:00:00', '17:00:00', 'cancelled', 85000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(56, 'BK-32005', NULL, 14, 32, 11, '2025-12-05', '18:00:00', '20:00:00', 'completed', 220000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'bca', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(57, 'BK-32006', NULL, 2, 32, 1, '2025-12-01', '21:00:00', '22:00:00', 'completed', 120000.00, NULL, NULL, '2025-12-19 01:04:23', NULL, 'gopay', NULL, NULL, NULL, '2025-12-19 01:04:23'),
(58, 'BK-A4642A', NULL, 1, 32, NULL, '2025-12-19', '13:00:00', '14:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-19 01:05:25', NULL, 'dana', NULL, NULL, NULL, '2025-12-19 01:05:25'),
(59, 'BK-FED592', NULL, 1, 32, NULL, '2025-12-19', '14:00:00', '15:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-19 01:16:16', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:16:16'),
(60, 'BK-6B6A82', NULL, 2, 32, NULL, '2025-12-19', '09:00:00', '10:00:00', 'booked', 100000.00, NULL, NULL, '2025-12-19 01:28:37', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:28:37'),
(61, 'BK-E8162A', NULL, 2, 32, NULL, '2025-12-19', '08:00:00', '09:00:00', 'booked', 100000.00, NULL, NULL, '2025-12-19 01:29:08', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:29:08'),
(62, 'BK-AD54D0', NULL, 1, 32, NULL, '2025-12-19', '16:00:00', '17:00:00', 'booked', 120000.00, NULL, NULL, '2025-12-19 01:53:19', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:53:19'),
(63, 'BK-PEND01', NULL, 1, 32, NULL, '2025-12-25', '10:00:00', '11:00:00', '', 85000.00, NULL, NULL, '2025-12-19 01:57:53', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 01:57:53'),
(64, 'BK-PROC02', NULL, 2, 32, NULL, '2025-12-26', '14:00:00', '15:00:00', '', 60000.00, NULL, NULL, '2025-12-19 01:57:53', NULL, 'BCA', NULL, NULL, NULL, '2025-12-19 01:57:53'),
(65, 'BK-5CE1AA', NULL, 1, 32, NULL, '2025-12-19', '15:00:00', '16:00:00', '', 120000.00, NULL, NULL, '2025-12-19 02:03:46', NULL, 'GoPay', NULL, NULL, NULL, '2025-12-19 02:03:46');

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
(1, 1, 'Lapangan A (Rumput Sintetis)', 'Futsal', 120000.00, NULL, 'https://images.unsplash.com/photo-1605218427335-3a4dd8743486?q=80&w=800'),
(2, 1, 'Lapangan B (Vinyl)', 'Futsal', 100000.00, NULL, 'https://images.unsplash.com/photo-1624880357913-a8539238245b?q=80&w=800'),
(3, 1, 'Lapangan C (Interlock)', 'Futsal', 110000.00, NULL, 'https://images.unsplash.com/photo-1506192131976-72c676239513?q=80&w=800'),
(4, 2, 'Court 1 (Karpet Standar)', 'Badminton', 50000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800'),
(5, 2, 'Court 2 (Lantai Kayu)', 'Badminton', 45000.00, NULL, 'https://images.unsplash.com/photo-1626224583764-847890e0e966?q=80&w=800'),
(6, 2, 'Main Hall Basket', 'Basketball', 200000.00, NULL, 'https://images.unsplash.com/photo-1519861531473-920026393112?q=80&w=800'),
(7, 3, 'Kolam Renang Olympic', 'Swimming', 50000.00, NULL, 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800'),
(8, 3, 'Tennis Court A', 'Tennis', 150000.00, NULL, 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?q=80&w=800'),
(9, 6, 'Indoor Court A', 'Basketball', 350000.00, NULL, 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?q=80&w=800'),
(10, 6, 'Outdoor Court B', 'Basketball', 150000.00, NULL, 'https://images.unsplash.com/photo-1515523110800-9415d13b84a8?q=80&w=800'),
(11, 7, 'VIP Futsal 1', 'Futsal', 180000.00, NULL, 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=800'),
(12, 7, 'VIP Futsal 2', 'Futsal', 180000.00, NULL, 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800'),
(13, 7, 'Regular Futsal', 'Futsal', 130000.00, NULL, 'https://images.unsplash.com/photo-1577223625816-7546f13df25d?q=80&w=800'),
(14, 11, 'Mini Soccer 1', 'Mini Soccer', 450000.00, NULL, 'https://images.unsplash.com/photo-1551958219-acbc608c6377?q=80&w=800'),
(15, 11, 'Mini Soccer 2', 'Mini Soccer', 450000.00, NULL, 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?q=80&w=800'),
(16, 4, 'Lapangan Utama Setia Budi Court', 'Tennis, Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(17, 5, 'Lapangan Utama Tuntungan Futsal', 'Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(18, 8, 'Lapangan Utama Kelapa Gading Badminton', 'Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800&auto=format&fit=crop'),
(19, 9, 'Lapangan Utama GBK Tennis Outdoor', 'Tennis', 85000.00, NULL, 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?q=80&w=800&auto=format&fit=crop'),
(20, 10, 'Lapangan Utama Kebon Jeruk Sport', 'Futsal, Badminton', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(21, 12, 'Lapangan Utama Dago Atas Gym & Sport', 'Gym, Basketball', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(22, 13, 'Lapangan Utama Gor C-Tra Arena', 'Basketball', 85000.00, NULL, 'https://images.unsplash.com/photo-1546519638-68e109498ee2?q=80&w=800&auto=format&fit=crop'),
(23, 14, 'Lapangan Utama Surabaya Sport Center', 'Badminton, Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1526232761682-d26e03ac148e?q=80&w=800'),
(24, 15, 'Lapangan Utama Graha Futsal Family', 'Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800&auto=format&fit=crop'),
(31, 4, 'Center Court', 'Tennis', 150000.00, NULL, 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?q=80&w=800'),
(32, 5, 'Lapangan Matras', 'Futsal', 90000.00, NULL, 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?q=80&w=800'),
(33, 8, 'Court A (Karet)', 'Badminton', 60000.00, NULL, 'https://images.unsplash.com/photo-1613918108466-292b78a8ef95?q=80&w=800'),
(34, 9, 'Outdoor A', 'Tennis', 175000.00, NULL, 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?q=80&w=800'),
(35, 10, 'Futsal Pitch 1', 'Futsal', 110000.00, NULL, 'https://images.unsplash.com/photo-1605218427335-3a4dd8743486?q=80&w=800'),
(36, 10, 'Badminton Hall', 'Badminton', 50000.00, NULL, 'https://images.unsplash.com/photo-1626224583764-847649623d9c?q=80&w=800'),
(37, 12, 'Gym Area', 'Gym', 50000.00, NULL, 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800'),
(38, 12, 'Rooftop Basket', 'Basketball', 120000.00, NULL, 'https://images.unsplash.com/photo-1546519638-68e109498ee3?q=80&w=800'),
(39, 13, 'Main Arena', 'Basketball', 250000.00, NULL, 'https://images.unsplash.com/photo-1505666287802-931dc83948e9?q=80&w=800'),
(40, 14, 'PBSI Court 1', 'Badminton', 75000.00, NULL, 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?q=80&w=800'),
(41, 15, 'Family Pitch', 'Futsal', 85000.00, NULL, 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800');

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
(1, 32, 'booking', 'Booking Dikonfirmasi', 'Pesanan Anda di Galaxy Futsal (Lapangan A) telah berhasil dikonfirmasi.', 0, '2025-12-19 00:51:57'),
(2, 32, 'promo', 'Promo Akhir Pekan', 'Diskon 30% untuk semua lapangan Badminton khusus hari Sabtu!', 0, '2025-12-19 00:51:57'),
(3, 32, 'reminder', 'Pengingat Jadwal', 'Jangan lupa! Anda memiliki jadwal tanding 2 jam lagi.', 1, '2025-12-18 00:51:57'),
(4, 32, 'info', 'Poin Member Bertambah', 'Selamat! Anda mendapatkan 50 poin dari aktivitas booking kemarin.', 0, '2025-12-17 00:51:57'),
(5, 32, 'promo', 'Voucher Baru', 'Kamu punya voucher diskon Rp 20.000 yang akan kadaluarsa besok.', 0, '2025-12-16 00:51:57'),
(6, 32, 'booking', 'Booking Selesai', 'Terima kasih telah bermain di Senayan Basket Hall. Berikan ulasan Anda!', 1, '2025-12-15 00:51:57'),
(7, 32, 'info', 'Level Up!', 'Selamat! Anda sekarang telah mencapai Level Gold.', 0, '2025-12-14 00:51:57'),
(8, 32, 'info', 'Sistem Maintenance', 'Aplikasi akan melakukan pemeliharaan rutin pada jam 00:00 WIB malam ini.', 1, '2025-12-13 00:51:57'),
(9, 32, 'promo', 'Promo Cashback', 'Gunakan GoPay dan dapatkan cashback hingga Rp 10.000.', 1, '2025-12-12 00:51:57'),
(10, 32, 'info', 'Verifikasi Berhasil', 'Akun Anda telah terverifikasi sepenuhnya.', 1, '2025-12-09 00:51:57'),
(11, 32, 'booking', 'Booking Berhasil', 'Pesanan di Galaxy Futsal telah dikonfirmasi.', 0, '2025-12-19 00:54:34'),
(12, 32, 'promo', 'Promo Akhir Pekan', 'Diskon 20% khusus Sabtu-Minggu!', 0, '2025-12-19 00:54:34'),
(13, 32, 'info', 'Poin Bertambah', 'Anda mendapatkan 50 poin dari booking terakhir.', 1, '2025-12-19 00:54:34'),
(14, 32, 'booking', 'Booking Sukses!', 'Pesanan BK-77123 telah masuk ke sistem.', 0, '2025-12-19 01:00:22'),
(15, 32, 'promo', 'Promo Badminton', 'Diskon 50% untuk venue Gor Angsapura besok!', 0, '2025-12-19 01:00:22'),
(16, 32, 'info', 'Poin Bertambah', 'Selamat! +50 poin dari transaksi terakhir.', 1, '2025-12-19 01:00:22'),
(17, 32, 'info', 'Ulasan Dibutuhkan', 'Bagaimana pengalaman tanding Anda di Galaxy Futsal?', 0, '2025-12-19 01:00:22'),
(18, 32, 'info', 'Sistem Update', 'Aplikasi Sport Arena versi 2.0 sudah tersedia.', 1, '2025-12-19 01:00:22'),
(19, 32, 'booking', 'Pembayaran Berhasil', 'Booking BK-9902 telah dikonfirmasi oleh admin.', 1, '2025-12-19 01:02:11'),
(20, 32, 'promo', 'Promo Year End', 'Diskon 50% untuk booking lapangan Futsal di malam tahun baru!', 0, '2025-12-19 01:02:11'),
(21, 32, 'reminder', 'Reminder Tanding', 'Jadwal Anda di Galaxy Futsal dimulai 1 jam lagi.', 0, '2025-12-19 01:02:11'),
(22, 32, 'info', 'Poin Reward', 'Anda mendapatkan 20 poin tambahan dari ulasan terakhir.', 1, '2025-12-19 01:02:11'),
(23, 32, 'promo', 'Voucher Diskon', 'Gunakan kode SPORTMEDAN untuk potongan Rp 15.000.', 0, '2025-12-19 01:02:11'),
(24, 32, 'booking', 'Update Status', 'Booking BK-9904 telah berhasil dibatalkan.', 1, '2025-12-19 01:02:11'),
(25, 32, 'info', 'Member Gold', 'Selamat! Anda telah mencapai level Gold.', 0, '2025-12-19 01:02:11'),
(26, 32, 'info', 'Maintenance Sistem', 'Aplikasi akan tidak dapat diakses sementara pada jam 02:00 WIB.', 1, '2025-12-19 01:02:11'),
(27, 32, 'promo', 'Cashback GoPay', 'Dapatkan cashback 5% untuk setiap transaksi menggunakan GoPay.', 1, '2025-12-19 01:02:11'),
(28, 32, 'info', 'Verifikasi Akun', 'Selamat! Akun Anda telah terverifikasi sebagai member prioritas.', 1, '2025-12-19 01:02:11'),
(29, 32, 'booking', 'Booking Berhasil', 'Booking BK-32001 telah dikonfirmasi.', 0, '2025-12-19 01:04:23'),
(30, 32, 'promo', 'Promo Badminton', 'Diskon 30% khusus hari ini di GOR Angsapura!', 0, '2025-12-19 01:04:23'),
(31, 32, 'info', 'Level Up!', 'Selamat! Anda sekarang adalah Member Gold.', 1, '2025-12-19 01:04:23'),
(32, 32, 'promo', 'Cashback!', 'Dapatkan cashback 5% dengan bayar pakai GoPay.', 0, '2025-12-19 01:04:23'),
(33, 32, 'reminder', 'Ingat Jadwal', 'Jadwal tanding Anda tinggal 2 jam lagi.', 0, '2025-12-19 01:04:23'),
(34, 32, 'info', 'Review Venue', 'Bagaimana pengalaman Anda bermain di Senayan?', 1, '2025-12-19 01:04:23'),
(35, 32, 'info', 'Update Sistem', 'Aplikasi sekarang mendukung QR Code Payment.', 1, '2025-12-19 01:04:23'),
(36, 32, 'info', 'Bonus Poin', 'Anda mendapatkan 50 poin dari booking terakhir.', 0, '2025-12-19 01:04:23'),
(37, 32, 'promo', 'Voucher Baru', 'Gunakan kode MEDANSPORT untuk diskon 15rb.', 0, '2025-12-19 01:04:23'),
(38, 32, 'info', 'Sesi Selesai', 'Terima kasih telah berolahraga hari ini!', 1, '2025-12-19 01:04:23'),
(39, 32, 'booking', 'Booking Berhasil!', 'Tiket BK-AD54D0 untuk tanggal 2025-12-19 telah berhasil dipesan.', 0, '2025-12-19 01:53:19'),
(40, 32, 'booking', 'Pesanan Dibuat', 'Selesaikan pembayaran untuk tiket BK-5CE1AA', 0, '2025-12-19 02:03:46');

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

--
-- Dumping data for table `saved_payment_methods`
--

INSERT INTO `saved_payment_methods` (`id`, `user_id`, `type`, `name`, `detail`, `is_default`) VALUES
(1, 32, 'wallet', 'GoPay', '0812-****-3232', 1),
(2, 32, 'bank', 'BCA Virtual Account', '8837-0000-3232-11', 0),
(3, 32, 'wallet', 'OVO', '0812-****-3232', 0),
(4, 32, 'bank', 'Mandiri Virtual Account', '900-1234-5678-32', 0);

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
(32, 'Gabriel Pardede', 'gabzy@gmail.com', '$2y$10$yDSd8Y8oj2UKUYvhMvKwcOjBMYqnuraJ2hpN7Tlc6rKoV5gFCtCqq', 'customer', '08311877712', '2025-12-18 16:14:06', 'active', 'uploads/profile_32_1766089314.jpg', 450),
(34, 'mel', 'mel@fer.com', '$2y$10$BCmPwfsx0mHoJZQoDFuFZOOn2ft7E2GRrpoCjcUPXsxIMeTKdx/PK', 'customer', '087899676872', '2025-12-18 22:40:06', 'active', NULL, 0);

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
(1, 'Galaxy Futsal Arena', 'Jl. Dr. Mansyur No. 88, Medan Baru', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800', NULL, NULL, 4.8, 3.5689, 98.6543, 'Medan', 'Futsal'),
(2, 'Gor Angsapura', 'Jl. Logam No. 12, Medan Area', 'https://images.unsplash.com/photo-1519861531473-9200262188bf?q=80&w=800', NULL, NULL, 4.5, 3.5852, 98.6756, 'Medan', 'Badminton, Basketball'),
(3, 'Cemara Sport Center', 'Komp. Cemara Asri, Percut Sei Tuan', 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800', NULL, NULL, 4.7, 3.6367, 98.7042, 'Medan', 'Swimming, Tennis'),
(4, 'Setia Budi Court', 'Jl. Setia Budi No. 45, Medan Sunggal', 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?q=80&w=800', NULL, NULL, 4.6, 3.5789, 98.6321, 'Medan', 'Tennis, Badminton'),
(5, 'Tuntungan Futsal', 'Jl. Jamin Ginting Km 12', 'https://images.unsplash.com/photo-1518609878373-06d740f60d8b?q=80&w=800', NULL, NULL, 4.2, 3.5112, 98.6123, 'Medan', 'Futsal'),
(6, 'Senayan Basket Hall', 'Gelora Bung Karno, Jakarta Pusat', 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?q=80&w=800', NULL, NULL, 4.9, -6.2183, 106.8026, 'Jakarta', 'Basketball'),
(7, 'Cilandak Town Futsal', 'Citos, Jakarta Selatan', 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=800', NULL, NULL, 4.4, -6.2912, 106.8011, 'Jakarta', 'Futsal'),
(8, 'Kelapa Gading Badminton', 'Jl. Boulevard Raya, Jakarta Utara', 'https://images.unsplash.com/photo-1626224583764-847649623d9c?q=80&w=800', NULL, NULL, 4.3, -6.1592, 106.9065, 'Jakarta', 'Badminton'),
(9, 'GBK Tennis Outdoor', 'Jl. Pintu Satu Senayan, Jakarta Pusat', 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?q=80&w=800', NULL, NULL, 4.8, -6.2145, 106.8001, 'Jakarta', 'Tennis'),
(10, 'Kebon Jeruk Sport', 'Jl. Panjang No. 5, Jakarta Barat', 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?q=80&w=800', NULL, NULL, 4.5, -6.1923, 106.7721, 'Jakarta', 'Futsal, Badminton'),
(11, 'Siliwangi Soccer Field', 'Jl. Lombok, Bandung Wetan', 'https://images.unsplash.com/photo-1551958219-acbc608c6377?q=80&w=800', NULL, NULL, 4.7, -6.9098, 107.6163, 'Bandung', 'Mini Soccer, Futsal'),
(12, 'Dago Atas Gym & Sport', 'Jl. Dago Pakar, Coblong', 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=800', NULL, NULL, 4.5, -6.8845, 107.6136, 'Bandung', 'Gym, Basketball'),
(13, 'Gor C-Tra Arena', 'Jl. Cikutra, Bandung', 'https://images.unsplash.com/photo-1505666287802-931dc83948e9?q=80&w=800', NULL, NULL, 4.6, -6.9034, 107.6432, 'Bandung', 'Basketball'),
(14, 'Surabaya Sport Center', 'Jl. Kertajaya, Gubeng', 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?q=80&w=800', NULL, NULL, 4.6, -7.2798, 112.7689, 'Surabaya', 'Badminton, Futsal'),
(15, 'Graha Futsal Family', 'Jl. Mayjen Sungkono, Dukuh Pakis', 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?q=80&w=800', NULL, NULL, 4.2, -7.2912, 112.7231, 'Surabaya', 'Futsal');

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
  ADD KEY `idx_booking_status` (`status`),
  ADD KEY `bookings_venue_fk` (`venue_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `fields`
--
ALTER TABLE `fields`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

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
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `fields` (`id`),
  ADD CONSTRAINT `bookings_venue_fk` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`);

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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Aktifkan jika sudah ada API
// import '../services/api_service.dart'; // Aktifkan jika sudah ada API

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Warna Utama
  final Color primaryColor = const Color(0xFF22c55e);
  bool isLoading = true;

  // --- MOCK DATA (Sesuai Gambar) ---
  // Nanti bisa diganti dengan data dari ApiService
  List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Booking Dikonfirmasi!',
      'message': 'Lapangan Futsal A pada 15 Jan 2025 jam 19:00 telah dikonfirmasi.',
      'time': '2 jam lalu',
      'type': 'booking', // booking, promo, reminder, info
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'Promo Spesial! 🎉',
      'message': 'Dapatkan diskon 20% untuk booking weekend. Gunakan kode: WEEKEND20',
      'time': '5 jam lalu',
      'type': 'promo',
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Pengingat Booking',
      'message': 'Jangan lupa! Booking Anda besok jam 18:00 di Lapangan Badminton B.',
      'time': '1 hari lalu',
      'type': 'reminder',
      'isRead': false,
    },
    {
      'id': 4,
      'title': 'Upgrade Member!',
      'message': 'Selamat! Anda telah naik ke level Member Gold dengan benefit lebih banyak.',
      'time': '3 hari lalu',
      'type': 'info',
      'isRead': true,
    },
    {
      'id': 5,
      'title': 'Booking Selesai',
      'message': 'Terima kasih telah bermain! Jangan lupa berikan ulasan.',
      'time': '1 minggu lalu',
      'type': 'booking',
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Simulasi loading data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => isLoading = false);
    });
    // _loadNotifs(); // Gunakan ini jika API sudah siap
  }

  /* // FUNGSI LOAD API (Disimpan untuk nanti)
  void _loadNotifs() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userId');
    if (uid != null) {
      final data = await ApiService.getNotifications(uid);
      if (mounted) {
        setState(() {
          notifications = data; 
          isLoading = false;
        });
      }
    }
  }
  */

  // Hitung notifikasi belum dibaca
  int get unreadCount => notifications.where((n) => n['isRead'] == false).length;

  // Fungsi Tandai Semua Dibaca
  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua notifikasi ditandai sudah dibaca")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih sesuai gambar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              "Notifikasi",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 8),
            // Badge Jumlah Notifikasi (Merah)
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$unreadCount",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        actions: [
          // Tombol Tandai Dibaca
          TextButton.icon(
            onPressed: unreadCount > 0 ? _markAllAsRead : null,
            icon: Icon(Icons.check_circle_outline, size: 18, color: unreadCount > 0 ? primaryColor : Colors.grey),
            label: Text(
              "Tandai Dibaca",
              style: TextStyle(
                color: unreadCount > 0 ? primaryColor : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationCard(notifications[index]);
                  },
                ),
    );
  }

  // --- WIDGET KARTU NOTIFIKASI ---
  Widget _buildNotificationCard(Map<String, dynamic> item) {
    // Tentukan Style berdasarkan tipe
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item['type']) {
      case 'booking':
        icon = Icons.calendar_today_outlined;
        iconColor = primaryColor;
        iconBg = const Color(0xFFF0FDF4); // Hijau muda banget
        break;
      case 'promo':
        icon = Icons.card_giftcard;
        iconColor = Colors.orange[700]!;
        iconBg = Colors.orange[50]!;
        break;
      case 'reminder':
        icon = Icons.notifications_outlined;
        iconColor = primaryColor;
        iconBg = const Color(0xFFF0FDF4);
        break;
      case 'info':
      default:
        icon = Icons.info_outline;
        iconColor = Colors.grey[600]!;
        iconBg = Colors.grey[100]!;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item['isRead'] ? Colors.white : const Color(0xFFF9FAFB), // Sedikit abu jika belum baca
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item['isRead'] ? Colors.grey.shade200 : primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Content Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    // Dot Hijau jika belum dibaca
                    if (!item['isRead'])
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['message'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("Tidak ada notifikasi", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
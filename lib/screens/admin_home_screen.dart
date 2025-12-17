import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'venue_list_admin_screen.dart'; // Admin Venue Management
// Pastikan Anda mengimpor file yang benar untuk tampilan dummy ini
// Jika Anda menggunakan struktur file yang lebih datar, pastikan path-nya benar
// Contoh: import 'verification_screen.dart'; 

// --- DUMMY SCREENS UNTUK NAVIGASI (Agar kode AdminHomeScreen tidak error) ---
class VerificationScreen extends StatelessWidget { 
  const VerificationScreen({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Verifikasi Booking')), body: const Center(child: Text('Halaman Verifikasi Pending Booking')));
}
class ReportsScreen extends StatelessWidget { 
  const ReportsScreen({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Laporan & Analitik')), body: const Center(child: Text('Halaman Laporan Penjualan/Ketersediaan')));
}
class UserManagementScreen extends StatelessWidget { 
  const UserManagementScreen({super.key}); 
  @override 
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Manajemen Pengguna')), body: const Center(child: Text('Halaman Daftar dan Edit Pengguna')));
}


class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final Color primaryColor = const Color(0xFF22c55e); // Hijau
  final Color secondaryColor = const Color(0xFFfacc15); // Kuning (Aksen)
  final Color bgColor = const Color(0xFFf9fafb);

  bool isLoading = true;

  // METRIK ADMIN (Disimulasikan, di aplikasi nyata diambil dari ApiService)
  Map<String, dynamic> adminStats = {
    "total_revenue": "-",
    "today_bookings": "-",
    "pending_verification": "-",
    "popular_court": "Loading...",
    "latest_booking": "Loading..."
  };

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() async {
    // Simulasi pengambilan data dashboard dari server
    final data = await _fetchAdminDataSimulated(); 

    if (mounted) {
      setState(() {
        adminStats = data;
        isLoading = false;
      });
    }
  }
  
  // SIMULASI FUNGSI API (API Service Anda harus memiliki fungsi ini)
  Future<Map<String, dynamic>> _fetchAdminDataSimulated() async {
    // Di aplikasi nyata, Anda akan menggunakan ApiService.getAdminDashboardData();
    await Future.delayed(const Duration(seconds: 1)); 
    return {
      "total_revenue": "Rp 25.4 Jt",
      "today_bookings": "8",
      "pending_verification": "2",
      "popular_court": "Lapangan Futsal A",
      "latest_booking": "Lapangan Futsal B (15:00)"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER DASHBOARD ---
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Admin Dashboard 🛠️',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ),
            
            // --- METRIK UTAMA BISNIS ---
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ringkasan Kinerja', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 12),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            _buildAdminStatCard(
                              adminStats['total_revenue'].toString(),
                              'Total Pemasukan',
                              Colors.green.shade700,
                            ),
                            const SizedBox(width: 12),
                            _buildAdminStatCard(
                              adminStats['today_bookings'].toString(),
                              'Booking Hari Ini',
                              secondaryColor,
                            ),
                          ],
                        ),
                ],
              ),
            ),

            // --- MENU AKSI CEPAT ADMIN ---
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text('Aksi & Manajemen Cepat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            _buildAdminActions(),

            // --- RINGKASAN AKTIVITAS TERBARU ---
            _buildLatestActivitySummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(val, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _actionItem(
            Icons.verified_user, 
            'Verifikasi Pending', 
            primaryColor, 
            adminStats['pending_verification'].toString(), 
            const VerificationScreen()
          ),
          _actionItem(
            Icons.receipt_long, 
            'Laporan & Analitik', 
            Colors.blue, 
            'Lihat', 
            const ReportsScreen()
          ),
          // Admin akan mengklik ini untuk mengelola Lapangan/Venue
          _actionItem(
            Icons.business_center, 
            'Manajemen Venue', 
            Colors.purple, 
            'Kelola', 
            const VenueListAdminScreen() 
          ),
        ],
      ),
    );
  }
  
  Widget _actionItem(IconData icon, String title, Color color, String subtitle, Widget targetScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestActivitySummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktivitas Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          // Kartu Lapangan Terpopuler
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lapangan Terpopuler Saat Ini:', style: TextStyle(color: Colors.grey)),
                    Text(adminStats['popular_court'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  ],
                ),
                Icon(Icons.trending_up, color: primaryColor, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Kartu Booking Baru
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Booking Baru:', style: TextStyle(color: Colors.grey)),
                    Text(adminStats['latest_booking'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  ],
                ),
                const Icon(Icons.receipt_long, color: Colors.orange, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
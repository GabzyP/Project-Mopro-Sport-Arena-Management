import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import 'auth_screen.dart';
import 'admin_orders_screen.dart'; 
import 'venue_list_admin_screen.dart'; 
import 'admin_booking_settings_page.dart'; 
import 'admin_customer_management_page.dart';
import 'admin_ad_management_page.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool isLoading = true;
  String totalBookings = "0";
  String totalCustomers = "0";
  String activeAds = "2";

  final Color headerColor = const Color(0xFF3E2723);
  final Color goldColor = const Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await ApiService.getAdminDashboardData();
    if (mounted) {
      setState(() {
        final stats = data['stats'] ?? {};
        final orders = data['orders'] as List? ?? [];
        totalBookings = orders.length.toString();
        totalCustomers = stats['active_users']?.toString() ?? "0";
        isLoading = false;
      });
    }
  }

  void _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  // Fungsi Navigasi Baru
  void _navigateTo(Widget target) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF22c55e),
                      child: Text("AA", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Admin Arena", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("admin@sportarena.com", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  _buildBadge("Super Admin"),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  _buildStatCard(totalBookings, "Total Booking"),
                  const SizedBox(width: 12),
                  _buildStatCard(totalCustomers, "Customer"),
                  const SizedBox(width: 12),
                  _buildStatCard(activeAds, "Iklan Aktif"),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuItem(
                    Icons.calendar_today,
                    "Pengaturan Booking",
                    "Atur auto confirm & notifikasi",
                    // SEKARANG MEMBUKA HALAMAN BARU
                    onTap: () => _navigateTo(const AdminBookingSettingsPage()), 
                  ),
                  _buildMenuItem(
                    Icons.people_outline,
                    "Kelola Customer",
                    "Lihat & banned akun customer",
                    // NAVIGASI KE HALAMAN CUSTOMER (Ganti Scaffold dengan screen asli jika sudah ada)
                   onTap: () => _navigateTo(const AdminCustomerManagementPage()), 
),
                  _buildMenuItem(
                    Icons.campaign_outlined,
                    "Kelola Iklan",
                    "Buat & kelola promo",
                    // NAVIGASI KE HALAMAN IKLAN (Ganti Scaffold dengan screen asli jika sudah ada)
                    onTap: () => _navigateTo(const AdminAdManagementPage()), 
),
                  _buildMenuItem(
                    Icons.storefront,
                    "Info Venue",
                    "Informasi venue & operasional",
                    onTap: () => _navigateTo(const VenueListAdminScreen()), 
                  ),

                  const SizedBox(height: 24),
                  _buildLogoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER TETAP SAMA ---
  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("👑", style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF22c55e))),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: _handleLogout,
      icon: const Icon(Icons.logout, size: 20),
      label: const Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
      style: TextButton.styleFrom(foregroundColor: Colors.red, alignment: Alignment.centerLeft),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'venue_list_admin_screen.dart';
import 'add_field_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Verifikasi Booking',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada verifikasi tertunda',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Laporan & Analitik',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Menyiapkan data analitik...',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Manajemen Pengguna',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Daftar pengguna sedang dimuat',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  final Color secondaryColor = const Color(0xFFfacc15);
  final Color bgColor = const Color(0xFFf8fafc);

  bool isLoading = true;

  Map<String, dynamic> adminStats = {
    "total_revenue": "-",
    "today_bookings": "-",
    "pending_verification": "-",
    "popular_court": "Loading...",
    "latest_booking": "Loading...",
  };

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() async {
    final data = await _fetchAdminDataSimulated();

    if (mounted) {
      setState(() {
        adminStats = data;
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchAdminDataSimulated() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      "total_revenue": "Rp 25.4 Jt",
      "today_bookings": "8",
      "pending_verification": "2",
      "popular_court": "Lapangan Futsal A",
      "latest_booking": "Lapangan Futsal B (15:00)",
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
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, const Color(0xFF16a34a)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dashboard 🛠️',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings_suggest_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Kinerja',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e293b),
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : Row(
                          children: [
                            _buildAdminStatCard(
                              adminStats['total_revenue'].toString(),
                              'Pemasukan',
                              Colors.white,
                              primaryColor,
                              Icons.account_balance_wallet_rounded,
                            ),
                            const SizedBox(width: 16),
                            _buildAdminStatCard(
                              adminStats['today_bookings'].toString(),
                              'Booking Hari Ini',
                              Colors.white,
                              secondaryColor,
                              Icons.calendar_today_rounded,
                            ),
                          ],
                        ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aksi & Manajemen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e293b),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildAdminActions(),

            const SizedBox(height: 32),
            _buildLatestActivitySummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatCard(
    String val,
    String label,
    Color bgColor,
    Color accentColor,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              val,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0f172a),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
        children: [
          _actionItem(
            Icons.verified_rounded,
            'Verifikasi',
            primaryColor,
            const VerificationScreen(),
          ),
          _actionItem(
            Icons.analytics_rounded,
            'Analitik',
            Colors.blue,
            const ReportsScreen(),
          ),
          _actionItem(
            Icons.apartment_rounded,
            'Venues',
            Colors.deepPurple,
            const VenueListAdminScreen(),
          ),
        ],
      ),
    );
  }

  Widget _actionItem(
    IconData icon,
    String title,
    Color color,
    Widget targetScreen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestActivitySummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1e293b),
                ),
              ),
              Icon(
                Icons.history_rounded,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _activityCard(
            'Lapangan Terpopuler',
            adminStats['popular_court'].toString(),
            Icons.stars_rounded,
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _activityCard(
            'Booking Terbaru',
            adminStats['latest_booking'].toString(),
            Icons.notifications_active_rounded,
            primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _activityCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF0f172a),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

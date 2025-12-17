import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class ProfileMenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;

  ProfileMenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "Loading...";
  String _userRole = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? "Tamu";
      _userRole = prefs.getString('userRole') == 'admin'
          ? "Administrator"
          : "Member Gold";
    });
  }

  void _handleLogout() async {
    await AuthService.logout();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil keluar")));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF22c55e);
    final secondaryColor = Colors.orange;

    final List<ProfileMenuItem> menuItems = [
      ProfileMenuItem(
        icon: Icons.credit_card,
        label: 'Metode Pembayaran',
        badge: '2 kartu',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.history,
        label: 'Riwayat Booking',
        badge: '1 aktif',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.star_outline,
        label: 'Lapangan Favorit',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifikasi',
        badge: '3 baru',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.rate_review_outlined,
        label: 'Ulasan Saya',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyReviewsScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.settings_outlined,
        label: 'Pengaturan',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.help_outline,
        label: 'Bantuan',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpScreen()),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 16, left: 20),
                centerTitle: false,
                title: Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20, bottom: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text("👤", style: TextStyle(fontSize: 32)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            _userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Status: $_userRole",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Verified Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _buildStatCard(
                    context,
                    "24",
                    "Total Booking",
                    primaryColor,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingHistoryScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    "⚽",
                    "Favorit",
                    secondaryColor,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    "4.8",
                    "Rating",
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyReviewsScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ...menuItems
                    .map((item) => _buildMenuCard(item, primaryColor))
                    .toList(),

                const SizedBox(height: 16),

                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Konfirmasi Keluar"),
                        content: const Text("Apakah Anda yakin ingin keluar?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Batal",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleLogout();
                            },
                            child: const Text(
                              "Keluar",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Keluar",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.withOpacity(0.2)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(ProfileMenuItem item, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(item.icon, color: primaryColor, size: 20),
        ),
        title: Text(
          item.label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: item.onTap,
      ),
    );
  }
}

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Metode Pembayaran"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Pembayaran")),
  );
}

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Riwayat Booking"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Riwayat")),
  );
}

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Favorit"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Favorit")),
  );
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Notifikasi"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Notifikasi")),
  );
}

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Ulasan Saya"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Ulasan")),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Pengaturan"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Pengaturan")),
  );
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Bantuan"),
      backgroundColor: const Color(0xFF22c55e),
    ),
    body: const Center(child: Text("Halaman Bantuan")),
  );
}

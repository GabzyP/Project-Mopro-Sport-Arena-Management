import 'package:flutter/material.dart';

// --- MODEL MENU ITEM ---
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

// =================================================================
// ===== TEMPORARY SCREENS (Placeholder classes)
// =================================================================

// ===== PAYMENT METHOD SCREEN =====
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    final List<Map<String, dynamic>> cards = [
      {"name": "Visa **** 4242", "icon": "💳", "default": true},
      {"name": "Mastercard **** 8888", "icon": "💳", "default": false},
    ];

    final List<Map<String, dynamic>> emoneyOptions = [

      {"name": "Gopay", "icon": "💚", "onTap": () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akan menautkan ke Gopay")),
        );
      }},
       {"name": "Dana", "icon": "T", "onTap": () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akan menautkan ke OVO")),
        );
      }},
      {"name": "OVO", "icon": "💜", "onTap": () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akan menautkan ke OVO")),
        );
      }},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Metode Pembayaran"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN KARTU SAYA ---
            const Text(
              "Kartu Saya",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...cards.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Text(p["icon"] as String, style: const TextStyle(fontSize: 30)),
                title: Text(p["name"] as String),
                trailing: (p["default"] as bool)
                    ? Chip(
                        label: const Text("Utama", style: TextStyle(fontSize: 10)),
                        backgroundColor: primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        side: BorderSide(color: primaryColor.withOpacity(0.5)),
                      )
                    : const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            )),

            const SizedBox(height: 8),

            // Tombol Tambah Kartu
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const AddCardScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Tambah Kartu Baru"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: primaryColor),
                foregroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 30),

            // --- BAGIAN METODE LAIN (QRIS & E-MONEY) ---
            const Text(
              "Metode Lain",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...emoneyOptions.map((e) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Text(e["icon"] as String, style: const TextStyle(fontSize: 30)),
                title: Text(e["name"] as String),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: e["onTap"] as VoidCallback,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ===== NOTIFICATION SCREEN =====
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    final notifications = [
      {"title": "Booking Dikonfirmasi", "desc": "Lapangan A1 - 15 Des 2024", "time": "2 jam lalu", "unread": true},
      {"title": "Promo Spesial!", "desc": "Diskon 20% untuk member gold", "time": "1 hari lalu", "unread": true},
      {"title": "Pembayaran Berhasil", "desc": "Rp 150.000 - Booking #1234", "time": "3 hari lalu", "unread": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Tandai Semua Dibaca", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            color: (notif["unread"] as bool) ? primaryColor.withOpacity(0.05) : Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(Icons.notifications, color: primaryColor),
              ),
              title: Text(
                notif["title"] as String,
                style: TextStyle(
                  fontWeight: (notif["unread"] as bool) ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif["desc"] as String),
                  const SizedBox(height: 4),
                  Text(
                    notif["time"] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

// ===== MY REVIEWS SCREEN =====
class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    final reviews = [
      {"venue": "Lapangan A1", "rating": 5, "comment": "Lapangan sangat bagus dan bersih!", "date": "10 Des 2024"},
      {"venue": "Lapangan B2", "rating": 4, "comment": "Pelayanan ramah, tapi parkiran kurang luas", "date": "5 Des 2024"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ulasan Saya"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review["venue"] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        review["date"] as String,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < (review["rating"] as int) ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(review["comment"] as String),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===== HELP SCREEN =====
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    final faqs = [
      {"q": "Bagaimana cara booking lapangan?", "a": "Pilih lapangan > Pilih tanggal & waktu > Konfirmasi pembayaran"},
      {"q": "Metode pembayaran apa yang tersedia?", "a": "Kami menerima transfer bank, e-wallet, dan kartu kredit"},
      {"q": "Apakah bisa membatalkan booking?", "a": "Bisa, dengan ketentuan pembatalan H-1 untuk refund 100%"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("Hubungi Kami"),
              subtitle: const Text("0812-3456-7890"),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text("Email Support"),
              subtitle: const Text("support@fieldify.com"),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          const Text("Pertanyaan Umum", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...faqs.map((faq) => ExpansionTile(
                title: Text(faq["q"] as String),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(faq["a"] as String),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

// ===== SETTINGS SCREEN =====
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifBooking = true;
  bool _notifPromo = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SwitchListTile(
            title: const Text("Notifikasi Booking"),
            subtitle: const Text("Terima notifikasi status booking"),
            value: _notifBooking,
            activeColor: primaryColor,
            onChanged: (val) => setState(() => _notifBooking = val),
          ),
          SwitchListTile(
            title: const Text("Notifikasi Promo"),
            subtitle: const Text("Terima info promo dan diskon"),
            value: _notifPromo,
            activeColor: primaryColor,
            onChanged: (val) => setState(() => _notifPromo = val),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Tampilan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          SwitchListTile(
            title: const Text("Mode Gelap"),
            subtitle: const Text("Aktifkan tema gelap"),
            value: _darkMode,
            activeColor: primaryColor,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Ubah Password"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privasi & Keamanan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text("Hapus Akun", style: TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Hapus Akun"),
                  content: const Text("Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ===== BOOKING HISTORY SCREEN =====
class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    final bookings = [
      {"venue": "Lapangan A1", "date": "15 Des 2024", "time": "16:00 - 18:00", "status": "Selesai"},
      {"venue": "Lapangan B2", "date": "20 Des 2024", "time": "14:00 - 16:00", "status": "Akan Datang"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Booking"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: const Icon(Icons.sports_soccer, color: Colors.green),
              ),
              title: Text(booking["venue"] as String),
              subtitle: Text("${booking["date"]} • ${booking["time"]}"),
              trailing: Chip(
                label: Text(
                  booking["status"] as String,
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: booking["status"] == "Selesai"
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
                labelStyle: TextStyle(
                  color: booking["status"] == "Selesai" ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

// ===== FAVORITE SCREEN =====
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lapangan Favorit"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFavoriteItem(
            'Stadion Mini Cikini', 
            'Rating 4.9 (120 ulasan)', 
            '⚽', 
            primaryColor
          ),
          _buildFavoriteItem(
            'GOR Futsal Merah Putih', 
            'Rating 4.5 (80 ulasan)', 
            '🥅', 
            primaryColor
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(String title, String subtitle, String icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

// ===== ADD CARD SCREEN (Baru) =====
class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kartu Baru"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Kartu Kredit/Debit", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),

            // Nomor Kartu
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nomor Kartu",
                hintText: "XXXX XXXX XXXX XXXX",
                prefixIcon: const Icon(Icons.credit_card),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Pemilik Kartu
            TextField(
              decoration: InputDecoration(
                labelText: "Nama Pemilik Kartu",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Tanggal Kadaluarsa
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: "Kadaluarsa",
                      hintText: "MM/YY",
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // CVV
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    decoration: InputDecoration(
                      labelText: "CVV",
                      hintText: "XXX",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      counterText: "", // Hilangkan counter
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kartu baru berhasil ditambahkan!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Simpan Kartu", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// ===== PROFILE SCREEN (Disempurnakan & Dihapus Admin/Edit)
// =================================================================

class ProfileScreen extends StatelessWidget {
  // Data user sekarang disetel statis karena EditProfileScreen dihapus
  final String _userName = "Ahmad Fulan"; 
  final String _userEmail = "ahmad.fulan@email.com";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color.fromARGB(255, 31, 133, 40);
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
        icon: Icons.history, // Mengganti riwayat booking ke menu utama
        label: 'Riwayat Booking',
        badge: '1 aktif',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
        ),
      ),
      ProfileMenuItem(
        icon: Icons.star_outline,
        label: 'Lapangan Favorit', // Mengganti nama label agar lebih umum
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
          // --- HEADER & APP BAR ---
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
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
                            _userEmail, 
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emoji_events, color: Colors.amber, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "Member Gold",
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

          // --- STATS ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _buildStatCard(context, "24", "Total Booking", primaryColor, () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
                  )),
                  const SizedBox(width: 12),
                  _buildStatCard(context, "⚽", "Favorit", secondaryColor, () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                  )),
                  const SizedBox(width: 12),
                  _buildStatCard(context, "4.8", "Rating", Colors.green, () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyReviewsScreen()),
                  )),
                ],
              ),
            ),
          ),

          // --- MENU LIST ---
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  ...menuItems.map(
                    (item) => _buildMenuCard(item, primaryColor),
                  ).toList(),

                  const SizedBox(height: 16),

                  // Logout Button
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
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Berhasil keluar")),
                                );
                                // TODO: Arahkan ke LoginScreen
                              },
                              child: const Text(
                                "Keluar",
                                style: TextStyle(color: Colors.red),
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
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color, VoidCallback onTap) {
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
        onTap: item.onTap,
      ),
    );
  }
}

// =================================================================
// ===== MAIN APP (Untuk menjalankan contoh)
// =================================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fieldify Profile',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreenWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghapus fungsi onAdminClick yang tidak digunakan lagi
    return const ProfileScreen(); 
  }
}
// ===== Kode EditProfileScreen dan _EditProfileScreenState DIHAPUS =====
// ===== Kode AddCardScreen Tetap Ada =====
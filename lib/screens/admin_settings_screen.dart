import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import 'auth_screen.dart';
import 'admin_booking_settings_page.dart';
import 'admin_customer_management_page.dart';
import 'admin_ad_management_page.dart';
import 'venue_list_admin_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  String _userName = "Admin Arena";
  String _userEmail = "admin@arena.com";
  String? _userId;
  String? _profilePhotoUrl;
  bool isLoading = true;

  final Color primaryColor = const Color(0xFF22c55e);

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final userDetails = await ApiService.getUserDetails(userId);

      if (mounted) {
        setState(() {
          _userId = userId;
          _userName =
              userDetails['name'] ?? prefs.getString('userName') ?? "Admin";
          _userEmail =
              userDetails['email'] ??
              prefs.getString('userEmail') ??
              "admin@arena.com";
          _profilePhotoUrl =
              userDetails['image_url'] ?? prefs.getString('userPhoto');
          isLoading = false;
        });

        // Update cache
        await prefs.setString('userName', _userName);
        await prefs.setString('userEmail', _userEmail);
        if (_profilePhotoUrl != null) {
          await prefs.setString('userPhoto', _profilePhotoUrl!);
        }
      }
    }
  }

  Future<void> _changePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && _userId != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mengupload foto...")));

      final result = await ApiService.updateProfilePhoto(
        _userId!,
        File(image.path),
      );

      if (result['status'] == 'success') {
        setState(() {
          _profilePhotoUrl = result['image_url'];
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userPhoto', result['image_url']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto berhasil diupdate!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(result['message'])));
        }
      }
    }
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin keluar dari Admin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => const AuthScreen()),
                  (r) => false,
                );
              }
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profil Admin"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Semua kolom harus diisi")),
                );
                return;
              }
              Navigator.pop(context);

              if (_userId != null) {
                final result = await ApiService.updateProfile(
                  userId: _userId!,
                  name: nameController.text,
                  email: emailController.text,
                );

                if (result['status'] == 'success') {
                  _loadAdminData(); // Reload
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profil berhasil diupdate")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal: ${result['message']}")),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      body: Stack(
        children: [
          // Background Image Header
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1522770179533-24471fcdba45?q=80&w=2000&auto=format&fit=crop', // Office/Admin minimalist vibe
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _changePhoto,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _getProfileImage(),
                                  child: _profilePhotoUrl == null
                                      ? const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _userName,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    onPressed: _showEditProfileDialog,
                                    tooltip: "Edit Profil",
                                  ),
                                ],
                              ),
                              Text(
                                _userEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildAdminBadge(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Menu Items
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          Icons.settings_applications,
                          "Pengaturan Booking",
                          "Atur auto-confirm & limitasi",
                          onTap: () =>
                              _navigateTo(const AdminBookingSettingsPage()),
                        ),
                        _buildMenuTile(
                          Icons.people_outline,
                          "Kelola Customer",
                          "Daftar pengguna & status",
                          onTap: () =>
                              _navigateTo(const AdminCustomerManagementPage()),
                        ),
                        _buildMenuTile(
                          Icons.campaign_outlined,
                          "Kelola Iklan",
                          "Tambah atau hapus banner promo",
                          onTap: () =>
                              _navigateTo(const AdminAdManagementPage()),
                        ),
                        _buildMenuTile(
                          Icons.storefront,
                          "Informasi Venue",
                          "Edit nama, lokasi & fasilitas",
                          onTap: () =>
                              _navigateTo(const VenueListAdminScreen()),
                        ),

                        const SizedBox(height: 24),
                        _buildMenuTile(
                          Icons.logout,
                          "Keluar",
                          "Akhiri sesi admin",
                          isDanger: true,
                          onTap: _handleLogout,
                        ),
                        const SizedBox(height: 100),
                      ],
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

  void _navigateTo(Widget target) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => target));
  }

  Widget _buildAdminBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.security, color: Colors.white, size: 14),
          SizedBox(width: 6),
          Text(
            "Super Admin",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    String subtitle, {
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(0.1)
                : primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDanger ? Colors.red : primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDanger ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
      if (_profilePhotoUrl!.startsWith('http')) {
        return NetworkImage(_profilePhotoUrl!);
      }
      return NetworkImage("${ApiService.baseUrl}/$_profilePhotoUrl");
    }
    return null;
  }
}

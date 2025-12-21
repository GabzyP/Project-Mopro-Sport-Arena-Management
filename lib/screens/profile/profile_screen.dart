import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok6_sportareamanagement/services/auth_service.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';
import 'package:kelompok6_sportareamanagement/screens/auth/auth_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/level_member_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/payment_method_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/favorite_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/my_review_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/setting_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/help_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = "Loading...";
  String _userEmail = "Loading...";
  String? _userId;
  String? _profilePhotoUrl;
  int _userPoints = 0;

  final Color primaryColor = const Color(0xFF22c55e);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final userDetails = await ApiService.getUserDetails(userId);

      setState(() {
        _userId = prefs.getString('userId');
        _userName = prefs.getString('userName') ?? "User";
        _userEmail = prefs.getString('userEmail') ?? "email@tidak.ditemukan";
        _profilePhotoUrl = prefs.getString('userPhoto');
        _userPoints = prefs.getInt('userPoints') ?? 0;

        _userName = userDetails['name'] ?? _userName;
        _userEmail = userDetails['email'] ?? _userEmail;
        _profilePhotoUrl = userDetails['image_url'] ?? _profilePhotoUrl;
        _userPoints =
            int.tryParse((userDetails['points'] ?? '0').toString()) ??
            _userPoints;
      });

      await prefs.setString('userName', _userName);
      await prefs.setString('userEmail', _userEmail);
      await prefs.setInt('userPoints', _userPoints);
      if (_profilePhotoUrl != null)
        await prefs.setString('userPhoto', _profilePhotoUrl!);
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto berhasil diupdate!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin keluar?"),
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

  String _getMemberTierName(int points) {
    if (points >= 1000000) return "Master";
    if (points >= 100000) return "Diamond";
    if (points >= 10000) return "Platinum";
    if (points >= 2000) return "Gold";
    if (points >= 500) return "Silver";
    if (points >= 100) return "Bronze";
    return "Member";
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'Master':
        return Colors.black;
      case 'Diamond':
        return Colors.blue;
      case 'Platinum':
        return Colors.teal;
      case 'Gold':
        return Colors.amber;
      case 'Silver':
        return Colors.grey;
      case 'Bronze':
        return Colors.brown;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1577223625816-7546f13df25d?q=80&w=2070&auto=format&fit=crop',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
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
                              Text(
                                _userName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildMemberBadge(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMenuTile(
                          Icons.payment,
                          "Metode Pembayaran",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentMethodScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          Icons.favorite_outline,
                          "Favorit Saya",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoriteScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          Icons.star_outline,
                          "Ulasan Saya",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyReviewsScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          Icons.help_outline,
                          "Bantuan",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          Icons.settings_outlined,
                          "Pengaturan",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        _buildMenuTile(
                          Icons.logout,
                          "Keluar",
                          isDanger: true,
                          onTap: _handleLogout,
                        ),
                        const SizedBox(height: 40),
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

  ImageProvider? _getProfileImage() {
    if (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty) {
      return NetworkImage("${ApiService.baseUrl}/$_profilePhotoUrl");
    }
    return null;
  }

  Widget _buildMemberBadge() {
    String tierName = _getMemberTierName(_userPoints);
    Color tierColor = _getTierColor(tierName);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LevelMemberScreen(currentPoints: _userPoints),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              color: tierColor == Colors.black ? Colors.white : tierColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              "Member $tierName",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title, {
    String? badge,
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isDanger
                ? Colors.red
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (badge != null) const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}

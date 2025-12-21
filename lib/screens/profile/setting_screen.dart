import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok6_sportareamanagement/theme_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';
import 'package:kelompok6_sportareamanagement/services/auth_service.dart';
import 'package:kelompok6_sportareamanagement/screens/auth/auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifPush = true;
  bool notifEmail = true;
  String? userId;
  String? userName;
  String? userEmail;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      userName = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _updateLocalUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    _loadUserData();
  }

  Future<void> _changePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null && userId != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mengupload foto...")));

      final result = await ApiService.updateProfilePhoto(
        userId!,
        File(image.path),
      );

      if (!mounted) return;

      if (result['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userPhoto', result['image_url']);
        await _loadUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto berhasil diupdate!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal: ${result['message']}")));
      }
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profil"),
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

              final result = await ApiService.updateProfile(
                userId: userId!,
                name: nameController.text,
                email: emailController.text,
              );

              if (!mounted) return;

              if (result['status'] == 'success') {
                await _updateLocalUser(
                  nameController.text,
                  emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${result['message']}")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ubah Password"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassController,
                decoration: const InputDecoration(labelText: "Password Lama"),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                decoration: const InputDecoration(labelText: "Password Baru"),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPassController,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (oldPassController.text.isEmpty ||
                  newPassController.text.isEmpty ||
                  confirmPassController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Semua kolom harus diisi")),
                );
                return;
              }

              if (newPassController.text != confirmPassController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password baru tidak cocok")),
                );
                return;
              }

              Navigator.pop(context);

              final result = await ApiService.changePassword(
                userId: userId!,
                oldPassword: oldPassController.text,
                newPassword: newPassController.text,
              );

              if (!mounted) return;

              if (result['status'] == 'success') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password berhasil diubah!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: ${result['message']}")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection("Akun", [
              _buildSettingItem(
                Icons.person,
                "Edit Profil",
                "Ubah nama, email",
                isLink: true,
                onTap: _showEditProfileDialog,
              ),
              _buildSettingItem(
                Icons.camera_alt,
                "Ubah Foto Profil",
                "Ganti foto profil anda",
                isLink: true,
                onTap: _changePhoto,
              ),
              _buildSettingItem(
                Icons.lock,
                "Ubah Password",
                "Perbarui password akun",
                isLink: true,
                onTap: _showChangePasswordDialog,
              ),
            ]),
            _buildSection("Preferensi", [
              _buildSettingItem(
                Icons.notifications,
                "Notifikasi Push",
                "Info booking & promo",
                isToggle: true,
                val: notifPush,
                onChanged: (v) => setState(() => notifPush = v),
              ),
              _buildSettingItem(
                Icons.email,
                "Notifikasi Email",
                "Update via email",
                isToggle: true,
                val: notifEmail,
                onChanged: (v) => setState(() => notifEmail = v),
              ),
              _buildSettingItem(
                Icons.dark_mode,
                "Mode Gelap",
                "Tampilan tema gelap",
                isToggle: true,
                val: themeNotifier.value == ThemeMode.dark,
                onChanged: (v) {
                  themeNotifier.toggleTheme(v);
                },
              ),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthService.logout();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (r) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.red.withOpacity(0.1)
                      : Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Arena Sport v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle, {
    bool isLink = false,
    bool isToggle = false,
    bool? val,
    Function(bool)? onChanged,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF22c55e).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF22c55e), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey : Colors.black54,
        ),
      ),
      trailing: isToggle
          ? Switch(
              value: val!,
              onChanged: onChanged,
              activeColor: const Color(0xFF22c55e),
            )
          : Icon(
              Icons.chevron_right,
              color: isDark ? Colors.grey : Colors.grey,
            ),
      onTap: isToggle ? null : onTap,
    );
  }
}

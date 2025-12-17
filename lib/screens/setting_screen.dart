import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifPush = true;
  bool notifEmail = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection("Akun", [
              _buildSettingItem(
                Icons.person,
                "Edit Profil",
                "Ubah nama, email, foto",
                isLink: true,
              ),
              _buildSettingItem(
                Icons.lock,
                "Ubah Password",
                "Perbarui password akun",
                isLink: true,
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
                val: darkMode,
                onChanged: (v) => setState(() => darkMode = v),
              ),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AuthService.logout();
                  if (mounted)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (r) => false,
                    );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
  }) {
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
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: isToggle
          ? Switch(
              value: val!,
              onChanged: onChanged,
              activeColor: const Color(0xFF22c55e),
            )
          : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: isLink ? () {} : null,
    );
  }
}

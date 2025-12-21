import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AdminBookingSettingsPage extends StatefulWidget {
  const AdminBookingSettingsPage({super.key});

  @override
  State<AdminBookingSettingsPage> createState() =>
      _AdminBookingSettingsPageState();
}

class _AdminBookingSettingsPageState extends State<AdminBookingSettingsPage> {
  bool isPushNotifEnabled = true;
  bool isAutoConfirmEnabled = false;
  bool isLoading = true;
  final Color headerColor = const Color(0xFF3E2723);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await ApiService.getAdminSettings();
    if (mounted) {
      setState(() {
        isPushNotifEnabled =
            (settings['push_notif'] == 1 || settings['push_notif'] == '1');
        isAutoConfirmEnabled =
            (settings['auto_confirm'] == 1 || settings['auto_confirm'] == '1');
        isLoading = false;
      });
    }
  }

  void _updateSetting(String action, bool value) async {
    setState(() {
      if (action == 'toggle_notif') isPushNotifEnabled = value;
      if (action == 'toggle_auto_confirm') isAutoConfirmEnabled = value;
    });

    final success = await ApiService.updateAdminSettings(action, value);
    if (!success && mounted) {
      setState(() {
        if (action == 'toggle_notif') isPushNotifEnabled = !value;
        if (action == 'toggle_auto_confirm') isAutoConfirmEnabled = !value;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengupdate pengaturan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                  decoration: BoxDecoration(color: headerColor),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pengaturan Booking",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Atur sistem booking",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                        _buildSwitchTile(
                          "Push Notification",
                          "Terima notifikasi booking baru",
                          isPushNotifEnabled,
                          (val) => _updateSetting('toggle_notif', val),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            color: Colors.grey.shade100,
                            height: 1,
                          ),
                        ),
                        _buildSwitchTile(
                          "Auto Confirm",
                          "Konfirmasi otomatis setelah pembayaran sukses",
                          isAutoConfirmEnabled,
                          (val) => _updateSetting('toggle_auto_confirm', val),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF22c55e),
            activeColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

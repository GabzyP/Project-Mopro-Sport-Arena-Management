import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifs();
  }

  void _loadNotifs() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userId');
    if (uid != null) {
      final data = await ApiService.getNotifications(uid);
      if (mounted) {
        setState(() {
          notifications = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: const Color(0xFF22c55e),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(child: Text("Tidak ada notifikasi"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                bool isPromo = item['category'] == 'promo';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPromo
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      child: Icon(
                        isPromo ? Icons.discount : Icons.notifications,
                        color: isPromo ? Colors.orange : Colors.blue,
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['message']),
                        Text(
                          item['created_at'],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

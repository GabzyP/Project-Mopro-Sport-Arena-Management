import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminCustomerManagementPage extends StatefulWidget {
  const AdminCustomerManagementPage({super.key});

  @override
  State<AdminCustomerManagementPage> createState() => _AdminCustomerManagementPageState();
}

class _AdminCustomerManagementPageState extends State<AdminCustomerManagementPage> {
  final Color headerColor = const Color(0xFF3E2723); // Cokelat sesuai desain
  List<dynamic> customers = [];
  List<dynamic> filteredCustomers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  void _fetchCustomers() async {
    // Memanggil dashboard data untuk mendapatkan list user
    final data = await ApiService.getAdminDashboardData(); 
    if (mounted) {
      setState(() {
        // Data dummy jika API belum mengembalikan list users
        customers = data['users'] ?? [
          {'id': '1', 'name': 'Ahmad Rizki', 'email': 'ahmad@email.com', 'booking_count': 24, 'is_banned': false},
          {'id': '2', 'name': 'Budi Santoso', 'email': 'budi@email.com', 'booking_count': 18, 'is_banned': false},
          {'id': '3', 'name': 'Citra Dewi', 'email': 'citra@email.com', 'booking_count': 12, 'is_banned': true},
          {'id': '4', 'name': 'Dani Pratama', 'email': 'dani@email.com', 'booking_count': 8, 'is_banned': false},
        ];
        filteredCustomers = customers;
        isLoading = false;
      });
    }
  }

  void _filterSearch(String query) {
    setState(() {
      filteredCustomers = customers
          .where((user) => user['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Fungsi untuk memproses status banned ke server
  void _toggleBannedStatus(dynamic user) async {
    // Di sini Anda bisa memanggil ApiService.updateUserStatus
    debugPrint("Memproses status banned untuk: ${user['name']}");
    
    setState(() {
      user['is_banned'] = !user['is_banned'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(user['is_banned'] 
          ? "${user['name']} berhasil dibanned" 
          : "Akses ${user['name']} telah dipulihkan"),
        backgroundColor: user['is_banned'] ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int bannedCount = customers.where((u) => u['is_banned'] == true).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Kelola Customer",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Kelola akun customer",
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          // Search and Banned Count Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterSearch,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari customer...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$bannedCount Banned",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          // Customer List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCustomers.isEmpty 
                  ? const Center(child: Text("Customer tidak ditemukan"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final user = filteredCustomers[index];
                        return _buildCustomerCard(user);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(dynamic user) {
    String initials = user['name'].split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    bool isBanned = user['is_banned'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isBanned ? Colors.red.shade50 : Colors.green.shade50,
            child: Text(initials, 
              style: TextStyle(
                color: isBanned ? Colors.red : Colors.green, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(user['name'], 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isBanned) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.block, color: Colors.white, size: 10),
                            SizedBox(width: 4),
                            Text("Banned", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ]
                  ],
                ),
                Text(user['email'], style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text("${user['booking_count']} booking", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          
          // PopupMenuButton untuk tombol titik tiga (Banned Akun)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              if (value == 'banned') {
                _toggleBannedStatus(user);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'banned',
                child: Row(
                  children: [
                    Icon(
                      isBanned ? Icons.settings_backup_restore : Icons.person_remove_outlined, 
                      color: Colors.black87, 
                      size: 20
                    ),
                    const SizedBox(width: 8),
                    Text(isBanned ? 'Pulihkan Akun' : 'Banned Akun'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
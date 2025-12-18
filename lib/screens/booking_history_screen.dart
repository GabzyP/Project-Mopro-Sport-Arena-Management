import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> allBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');

    print("DEBUG: Sedang mengambil booking untuk User ID: $uid");

    if (uid != null && uid.isNotEmpty) {
      final data = await ApiService.getUserBookings(uid);

      print("DEBUG: Jumlah data ditemukan: ${data.length}");

      if (mounted) {
        setState(() {
          allBookings = data;
          isLoading = false;
        });
      }
    } else {
      print("DEBUG: User ID kosong/null. Pastikan sudah Login.");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Riwayat Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF22c55e),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF22c55e),
          tabs: const [
            Tab(text: "Semua"),
            Tab(text: "Aktif"),
            Tab(text: "Selesai"),
            Tab(text: "Batal"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList("all"),
                _buildList("active"),
                _buildList("completed"),
                _buildList("cancelled"),
              ],
            ),
    );
  }

  Widget _buildList(String filter) {
    List<dynamic> filtered = allBookings;
    if (filter == "active") {
      filtered = allBookings
          .where((b) => b['status'] == 'booked' || b['status'] == 'confirmed')
          .toList();
    } else if (filter == "completed") {
      filtered = allBookings.where((b) => b['status'] == 'completed').toList();
    } else if (filter == "cancelled") {
      filtered = allBookings.where((b) => b['status'] == 'cancelled').toList();
    }

    if (filtered.isEmpty) return _emptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildBookingCard(filtered[index]),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> item) {
    Color statusColor;
    Color statusBg;
    String statusText;

    String status = (item['status'] ?? '').toString().toLowerCase();

    switch (status) {
      case 'booked':
        statusColor = Colors.orange;
        statusBg = Colors.orange.shade50;
        statusText = "Menunggu";
        break;
      case 'confirmed':
        statusColor = Colors.blue;
        statusBg = Colors.blue.shade50;
        statusText = "Dikonfirmasi";
        break;
      case 'completed':
        statusColor = Colors.green;
        statusBg = Colors.green.shade50;
        statusText = "Selesai";
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusBg = Colors.red.shade50;
        statusText = "Dibatalkan";
        break;
      default:
        statusColor = Colors.grey;
        statusBg = Colors.grey.shade50;
        statusText = status;
    }

    String fieldName = item['field_name'] ?? item['venue_name'] ?? 'Lapangan';
    String sportType = item['sport_type'] ?? 'Umum';
    String date = item['booking_date'] ?? '';
    String startTime = item['start_time'] ?? '00:00:00';

    double price = double.tryParse(item['total_price'].toString()) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text("🏟️", style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            fieldName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sportType,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          startTime.substring(0, 5),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF22c55e),
                ),
              ),
              if (status == 'completed')
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF22c55e)),
                    ),
                    child: const Text(
                      "Booking Lagi",
                      style: TextStyle(fontSize: 12, color: Color(0xFF22c55e)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        const Text(
          "Belum ada riwayat booking",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

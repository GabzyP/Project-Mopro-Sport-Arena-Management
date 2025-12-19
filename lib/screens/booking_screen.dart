import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color brownColor = const Color(0xFF4E342E);
  final Color brownGradient = const Color(0xFF3E2723);

  String selectedFilter = 'all';
  List<Booking> allBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');

    if (uid != null) {
      final dynamicData = await ApiService.getUserBookings(uid);

      if (mounted) {
        setState(() {
          allBookings = (dynamicData as List)
              .map((item) => Booking.fromJson(item))
              .toList();
          isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Fungsi untuk simulasi update status dari Pending ke Processing
  void _handlePayment(String bookingId) async {
    bool success = await ApiService.updateOrderStatus(bookingId, 'processing');
    if (success) {
      _loadBookings(); // Refresh data setelah bayar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pembayaran Berhasil! Menunggu Konfirmasi Admin."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memproses pembayaran.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> displayedBookings = selectedFilter == 'all'
        ? allBookings
        : allBookings.where((b) => b.status == selectedFilter).toList();

    // Filter untuk pengelompokan tampilan
    List<Booking> upcoming = displayedBookings
        .where(
          (b) =>
              b.status == 'booked' ||
              b.status == 'pending' ||
              b.status == 'processing',
        )
        .toList();
    List<Booking> history = displayedBookings
        .where((b) => b.status == 'completed' || b.status == 'cancelled')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFf9fafb),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [brownColor, brownGradient]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Booking Saya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Kelola semua reservasi lapangan Anda",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _statCard(
                      allBookings.length.toString(),
                      "Total",
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      allBookings
                          .where((b) => b.status == 'booked')
                          .length
                          .toString(),
                      "Aktif",
                      Colors.green,
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      allBookings
                          .where((b) => b.status == 'completed')
                          .length
                          .toString(),
                      "Selesai",
                      Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _filterChip('all', 'Semua'),
                  _filterChip('pending', 'Belum Bayar'),
                  _filterChip('processing', 'Diproses'),
                  _filterChip('booked', 'Aktif'),
                  _filterChip('completed', 'Selesai'),
                  _filterChip('cancelled', 'Dibatalkan'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const Text(
                        "Mendatang",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...upcoming.map((b) => _bookingCard(b)),
                      const SizedBox(height: 20),
                    ],
                    if (history.isNotEmpty) ...[
                      const Text(
                        "Riwayat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...history.map((b) => _bookingCard(b)),
                    ],
                    if (displayedBookings.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text("Tidak ada booking"),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String id, String label) {
    bool isSelected = selectedFilter == id;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = id),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4E342E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _bookingCard(Booking booking) {
    Color statusColor = Colors.grey;
    String statusText = booking.status;
    IconData statusIcon = Icons.info;

    // Logika Tingkatan Status
    if (booking.status == 'pending') {
      statusColor = Colors.redAccent;
      statusText = "Belum Bayar";
      statusIcon = Icons.payment;
    } else if (booking.status == 'processing') {
      statusColor = Colors.blue;
      statusText = "Menunggu Konfirmasi";
      statusIcon = Icons.hourglass_empty;
    } else if (booking.status == 'booked') {
      statusColor = Colors.green;
      statusText = "Terkonfirmasi";
      statusIcon = Icons.check_circle;
    } else if (booking.status == 'cancelled') {
      statusColor = Colors.red;
      statusText = "Dibatalkan";
      statusIcon = Icons.cancel;
    } else if (booking.status == 'completed') {
      statusColor = Colors.grey;
      statusText = "Selesai";
      statusIcon = Icons.history;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAGIAN ATAS: ID TIKET & STATUS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID TIKET: ${booking.bookingCode}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: brownColor.withOpacity(0.6),
                        letterSpacing: 1.1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  booking.fieldName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  booking.venueName,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      booking.date,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    // FITUR: Jam Booking
                    Text(
                      "${booking.startTime} - ${booking.endTime}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // TOMBOL BAYAR (Muncul hanya jika status 'pending')
                if (booking.status == 'pending') ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handlePayment(booking.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Bayar Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Pembayaran",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "Rp ${booking.totalPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

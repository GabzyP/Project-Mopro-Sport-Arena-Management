import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  bool isLoading = true;

  List<dynamic> completedReviews = [];
  List<dynamic> pendingReviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final reviewsData = await ApiService.getUserReviews(userId);
      final bookingsData = await ApiService.getUserBookings(userId);

      if (mounted) {
        setState(() {
          completedReviews = reviewsData;
          isLoading = false;

          final completedBookings = bookingsData.where((b) {
            final status = b['status'];
            bool isPast = false;
            try {
              final dateParts = b['booking_date'].toString().split('-');
              final timeParts = b['end_time'].toString().split(':');
              final endDateTime = DateTime(
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
                int.parse(dateParts[2]),
                int.parse(timeParts[0]),
                int.parse(timeParts[1]),
              );
              isPast = endDateTime.isBefore(DateTime.now());
            } catch (_) {}

            return status == 'completed' ||
                ((status == 'booked' || status == 'confirmed') && isPast);
          }).toList();

          pendingReviews = completedBookings.where((booking) {
            bool reviewedById = completedReviews.any(
              (r) => r['booking_id'].toString() == booking['id'].toString(),
            );
            if (reviewedById) return false;

            return true;
          }).toList();
        });
      }
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  double get averageRating {
    if (completedReviews.isEmpty) return 0.0;
    double total = completedReviews.fold(
      0.0,
      (sum, item) => sum + (double.tryParse(item['rating'].toString()) ?? 0.0),
    );
    return total / completedReviews.length;
  }

  void _showWriteReviewDialog(Map<String, dynamic> booking) {
    int rating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Beri Ulasan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    booking['venue_name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    booking['field_name'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => setState(() => rating = index + 1),
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(labelText: "Komentar"),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (rating == 0) return;
                    Navigator.pop(ctx);
                    final prefs = await SharedPreferences.getInstance();
                    await ApiService.addReview(
                      userId: prefs.getString('userId')!,
                      venueName: booking['venue_name'],
                      sportType: booking['field_name'],
                      rating: rating,
                      comment: commentController.text,
                      bookingId: booking['id'].toString(),
                    );
                    _loadReviews();
                  },
                  child: const Text("Kirim"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteReview(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Ulasan?"),
        content: const Text("Ulasan ini akan dihapus permanen."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                completedReviews.remove(item);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Ulasan dihapus")));
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['venue_name'] ?? 'Venue',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  item['field_name'] ?? '-',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  item['booking_date'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showWriteReviewDialog(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text("Ulas"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Ulasan Saya",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStatCard(
                        "Total Ulasan",
                        "${completedReviews.length}",
                        Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        "Rata-rata",
                        averageRating.toStringAsFixed(1),
                        Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        "Pending",
                        "${pendingReviews.length}",
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (pendingReviews.isNotEmpty) ...[
                    const Text(
                      "Menunggu Ulasan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pendingReviews
                        .map((item) => _buildPendingCard(item))
                        .toList(),
                    const SizedBox(height: 24),
                  ],
                  const Text(
                    "Ulasan Terkirim",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (completedReviews.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Belum ada ulasan terkirim",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...completedReviews
                        .map((item) => _buildReviewCard(item))
                        .toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(dynamic item) {
    String venueName = item['venue_name'] ?? 'Venue';
    String fieldName = item['sport_type'] ?? '-';
    int rating = int.tryParse(item['rating'].toString()) ?? 0;
    String date = item['created_at'] ?? '';
    String comment = item['comment'] ?? '';

    IconData sportIcon = Icons.sports_soccer;
    Color iconColor = Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(sportIcon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venueName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      fieldName,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children:
                          List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          })..add(
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _deleteReview(item),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "\"$comment\"",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

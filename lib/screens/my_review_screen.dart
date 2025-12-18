import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

import 'package:flutter/material.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  bool isLoading = true;

  // --- MOCK DATA ---
  List<Map<String, dynamic>> pendingReviews = [
    {
      'id': 1,
      'venue': 'Basket Arena Pro',
      'field': 'Full Court',
      'date': '14 Jan 2025',
      'icon': Icons.sports_basketball,
      'color': Colors.orange
    },
    {
      'id': 2,
      'venue': 'Kolam Renang Olympic',
      'field': 'Lane 3-4',
      'date': '12 Jan 2025',
      'icon': Icons.pool,
      'color': Colors.blue
    },
  ];

  List<Map<String, dynamic>> completedReviews = [
    {
      'id': 101,
      'venue': 'Stadion Mini Jaya',
      'field': 'Lapangan Futsal A',
      'rating': 5,
      'date': '10 Jan 2025',
      'comment': 'Lapangan sangat bersih dan terawat. Pencahayaan bagus untuk main malam. Highly recommended!',
      'icon': Icons.sports_soccer,
      'color': Colors.blueAccent
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  // Hitung Rata-rata
  double get averageRating {
    if (completedReviews.isEmpty) return 0.0;
    double total = completedReviews.fold(0, (sum, item) => sum + (item['rating'] as int));
    return total / completedReviews.length;
  }

  // --- FUNGSI 1: TAMPILKAN DIALOG TULIS ULASAN ---
  void _showWriteReviewDialog(Map<String, dynamic> item) {
    int selectedRating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tulis Ulasan", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Venue
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], color: item['color']),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['venue'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(item['field'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bintang Rating
                  const Text("Rating"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setStateDialog(() => selectedRating = index + 1);
                        },
                        icon: Icon(
                          index < selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Input Komentar
                  const Text("Komentar (opsional)"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Ceritakan pengalaman Anda...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (selectedRating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mohon beri rating bintang")),
                      );
                      return;
                    }
                    _submitReview(item, selectedRating, commentController.text);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.send, size: 16, color: Colors.white),
                  label: const Text("Kirim Ulasan", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- FUNGSI 2: KIRIM ULASAN (PINDAHKAN DARI PENDING KE COMPLETED) ---
  void _submitReview(Map<String, dynamic> item, int rating, String comment) {
    setState(() {
      // Hapus dari pending
      pendingReviews.remove(item);
      
      // Tambah ke completed
      completedReviews.insert(0, {
        'id': item['id'],
        'venue': item['venue'],
        'field': item['field'],
        'rating': rating,
        'date': 'Hari ini', // Tanggal baru
        'comment': comment.isEmpty ? "Tidak ada komentar" : comment,
        'icon': item['icon'],
        'color': item['color'],
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ulasan berhasil dikirim!")),
    );
  }

  // --- FUNGSI 3: HAPUS ULASAN ---
  void _deleteReview(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Ulasan?"),
        content: const Text("Ulasan ini akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() {
                completedReviews.remove(item);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ulasan dihapus")),
              );
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
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
        title: const Text("Ulasan Saya", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
                  // HEADER STATISTIK
                  Row(
                    children: [
                      _buildStatCard("Total Ulasan", "${completedReviews.length + pendingReviews.length}", Colors.green),
                      const SizedBox(width: 12),
                      _buildStatCard("Rata-rata", averageRating.toStringAsFixed(1), Colors.orange),
                      const SizedBox(width: 12),
                      _buildStatCard("Pending", "${pendingReviews.length}", Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // SECTION MENUNGGU ULASAN
                  if (pendingReviews.isNotEmpty) ...[
                    const Text("Menunggu Ulasan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...pendingReviews.map((item) => _buildPendingCard(item)).toList(),
                    const SizedBox(height: 24),
                  ],

                  // SECTION ULASAN TERKIRIM
                  const Text("Ulasan Terkirim", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (completedReviews.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Belum ada ulasan terkirim", style: TextStyle(color: Colors.grey)),
                    ))
                  else
                    ...completedReviews.map((item) => _buildReviewCard(item)).toList(),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: item['color'].withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(item['icon'], color: item['color'], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['venue'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(item['field'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item['date'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showWriteReviewDialog(item), // PANGGIL DIALOG DI SINI
            icon: const Icon(Icons.edit, size: 14, color: Colors.white),
            label: const Text("Tulis", style: TextStyle(color: Colors.white, fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: item['color'].withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(item['icon'], color: item['color'], size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['venue'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(item['field'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < item['rating'] ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.amber,
                        );
                      })
                      ..add(
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(item['date'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol Edit & Hapus
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Opsional: Implementasi Edit (bisa pakai dialog yang sama tapi pre-filled)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur edit akan segera hadir")));
                    },
                    child: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _deleteReview(item), // PANGGIL HAPUS DI SINI
                    child: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
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
              "\"${item['comment']}\"",
              style: TextStyle(color: Colors.grey[700], fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
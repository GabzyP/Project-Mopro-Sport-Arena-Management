import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final Color primaryColor = const Color(0xFF22c55e);

  // --- MOCK DATA (Data Dumy Sesuai Gambar) ---
  List<Map<String, dynamic>> eWallets = [
    {
      'id': 'gopay',
      'name': 'GoPay',
      'icon': Icons.account_balance_wallet, // Placeholder icon
      'color': Colors.green,
      'number': '****8842',
      'isMain': true, // Status "Utama"
    },
    {
      'id': 'ovo',
      'name': 'OVO',
      'icon': Icons.monetization_on, // Placeholder icon
      'color': Colors.purple,
      'number': '****1234',
      'isMain': false,
    },
  ];

  List<Map<String, dynamic>> banks = [
    {
      'id': 'bca',
      'name': 'BCA',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'number': '****5678',
      'isMain': false,
    },
  ];

  // Fungsi Menghapus Metode Pembayaran
  void _deleteMethod(String type, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Metode?"),
        content: const Text("Anda yakin ingin menghapus metode pembayaran ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (type == 'wallet') {
                  eWallets.removeAt(index);
                } else {
                  banks.removeAt(index);
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Metode pembayaran dihapus")),
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
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOMBOL TAMBAH (Outline Green)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navigasi ke halaman tambah kartu
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur Tambah Kartu akan segera hadir")),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Tambah Metode Pembayaran"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SECTION E-WALLET
            _buildSectionHeader(Icons.phone_android, "E-Wallet"),
            const SizedBox(height: 12),
            if (eWallets.isEmpty) _buildEmptyState(),
            ...eWallets.asMap().entries.map((entry) {
              return _buildCardItem(entry.value, 'wallet', entry.key);
            }),

            const SizedBox(height: 24),

            // SECTION TRANSFER BANK
            _buildSectionHeader(Icons.account_balance, "Transfer Bank"),
            const SizedBox(height: 12),
            if (banks.isEmpty) _buildEmptyState(),
            ...banks.asMap().entries.map((entry) {
              return _buildCardItem(entry.value, 'bank', entry.key);
            }),

            const SizedBox(height: 24),

            // FOOTER INFO KEAMANAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // Warna abu-abu muda
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.credit_card, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Metode pembayaran aman",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Data kartu dan akun Anda terenkripsi dan aman. Kami tidak menyimpan informasi sensitif.",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget Header Per Section
  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Widget Kartu Metode Pembayaran
  Widget _buildCardItem(Map<String, dynamic> data, String type, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Icon Lingkaran
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(data['icon'], color: data['color'], size: 24),
          ),
          const SizedBox(width: 16),
          
          // Info Nama & Nomor
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    // Badge Utama (Jika ada)
                    if (data['isMain'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D4037), // Cokelat tua sesuai gambar
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Utama",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  data['number'],
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),

          // Tombol Hapus (Trash Icon)
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
            onPressed: () => _deleteMethod(type, index),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        "Belum ada metode tersimpan",
        style: TextStyle(color: Colors.grey[400], fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}
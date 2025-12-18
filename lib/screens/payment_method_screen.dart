import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  bool isLoading = true;

  List<dynamic> eWallets = [];
  List<dynamic> banks = [];

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  void _loadMethods() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');
    if (uid != null) {
      final data = await ApiService.getSavedPaymentMethods(uid);

      if (mounted) {
        setState(() {
          eWallets = [];
          banks = [];

          for (var item in data) {
            if (item['type'] == 'wallet' || item['type'] == 'ewallet') {
              eWallets.add(item);
            } else {
              banks.add(item);
            }
          }
          isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _deleteMethod(String type, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Metode?"),
        content: const Text(
          "Anda yakin ingin menghapus metode pembayaran ini?",
        ),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Fitur Tambah Kartu akan segera hadir",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Tambah Metode Pembayaran"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader(Icons.phone_android, "E-Wallet"),
                  const SizedBox(height: 12),
                  if (eWallets.isEmpty) _buildEmptyState(),
                  ...eWallets.asMap().entries.map((entry) {
                    return _buildCardItem(entry.value, 'wallet', entry.key);
                  }),

                  const SizedBox(height: 24),

                  _buildSectionHeader(Icons.account_balance, "Transfer Bank"),
                  const SizedBox(height: 12),
                  if (banks.isEmpty) _buildEmptyState(),
                  ...banks.asMap().entries.map((entry) {
                    return _buildCardItem(entry.value, 'bank', entry.key);
                  }),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.credit_card,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
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
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
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

  Widget _buildCardItem(Map<String, dynamic> data, String type, int index) {
    String name = data['name'] ?? 'Metode';
    String detail = data['detail'] ?? '****';
    bool isMain = (data['is_default'] == '1');

    IconData icon = Icons.credit_card;
    Color color = Colors.grey;
    if (name.toLowerCase().contains('gopay')) {
      icon = Icons.account_balance_wallet;
      color = Colors.green;
    } else if (name.toLowerCase().contains('ovo')) {
      icon = Icons.monetization_on;
      color = Colors.purple;
    } else if (name.toLowerCase().contains('bca')) {
      icon = Icons.account_balance;
      color = Colors.blue;
    }

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
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isMain) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D4037),
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
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
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
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

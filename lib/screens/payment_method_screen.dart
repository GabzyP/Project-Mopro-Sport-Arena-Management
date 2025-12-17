import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<dynamic> methods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  void _loadMethods() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userId');
    if (uid != null) {
      final data = await ApiService.getSavedPaymentMethods(uid);
      if (mounted) {
        setState(() {
          methods = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metode Pembayaran"),
        backgroundColor: const Color(0xFF22c55e),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Metode Tersimpan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : methods.isEmpty
                ? const Text(
                    "Belum ada metode tersimpan",
                    style: TextStyle(color: Colors.grey),
                  )
                : Column(
                    children: methods
                        .map(
                          (m) => Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.credit_card,
                                color: Colors.blue,
                              ),
                              title: Text(m['name']),
                              subtitle: Text(m['detail']),
                              trailing: m['is_default'] == '1'
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.delete_outline,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
            const SizedBox(height: 30),
            const Text(
              "Tambah Metode Baru",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildAddButton("Kartu Kredit/Debit", Icons.credit_card),
            _buildAddButton("E-Wallet", Icons.account_balance_wallet),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(String label, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(label),
        trailing: const Icon(Icons.add_circle_outline),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fitur tambah kartu segera hadir")),
          );
        },
      ),
    );
  }
}

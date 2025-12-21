import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  bool isLoading = true;

  List<dynamic> paymentMethods = [];

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  void _loadMethods() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');
    if (uid != null) {
      try {
        final data = await ApiService.getSavedPaymentMethods(uid);
        if (mounted) {
          setState(() {
            paymentMethods = data;
            isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  void _showAddMethodDialog() {
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    final imageController = TextEditingController(
      text: 'https://via.placeholder.com/100',
    );
    String selectedType = 'wallet';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Metode Pembayaran"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'wallet', child: Text("E-Wallet")),
                  DropdownMenuItem(value: 'bank', child: Text("M-Banking")),
                ],
                onChanged: (val) => selectedType = val!,
                decoration: const InputDecoration(labelText: "Tipe"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: balanceController,
                decoration: const InputDecoration(labelText: "Saldo Awal"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "URL Icon"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                Navigator.pop(ctx);
                _processAddMethod(
                  nameController.text,
                  selectedType,
                  double.tryParse(balanceController.text) ?? 0,
                  imageController.text,
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _processAddMethod(
    String name,
    String type,
    double balance,
    String imgUrl,
  ) async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');

    if (uid != null) {
      try {
        await ApiService.addPaymentMethod(
          userId: uid,
          name: name,
          type: type,
          balance: balance,
          imageUrl: imgUrl,
        );
        _loadMethods();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Metode berhasil ditambahkan!")),
        );
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menambah: $e")));
      }
    }
  }

  void _deleteMethod(String id, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Metode?"),
        content: const Text("Metode ini akan dihapus permanen dari akun Anda."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              _processDelete(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _processDelete(String id) async {
    setState(() => isLoading = true);
    try {
      await ApiService.deletePaymentMethod(id);
      _loadMethods();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Metode pembayaran dihapus")),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> eWallets = paymentMethods
        .where((m) => m['type'] == 'wallet' || m['type'] == 'ewallet')
        .toList();
    List<dynamic> banks = paymentMethods
        .where((m) => m['type'] == 'bank' || m['type'] == 'va')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showAddMethodDialog,
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
                  ...eWallets.map((item) => _buildCardItem(item)).toList(),

                  const SizedBox(height: 24),

                  _buildSectionHeader(Icons.account_balance, "Transfer Bank"),
                  const SizedBox(height: 12),
                  if (banks.isEmpty) _buildEmptyState(),
                  ...banks.map((item) => _buildCardItem(item)).toList(),

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

  Widget _buildCardItem(Map<String, dynamic> data) {
    String id = data['id'].toString();
    String name = data['name'] ?? 'Metode';
    double balance = double.tryParse(data['balance'].toString()) ?? 0.0;
    String imgUrl = data['image_url'] ?? '';

    Widget iconWidget;
    if (imgUrl.isNotEmpty && imgUrl.startsWith('http')) {
      iconWidget = Image.network(
        imgUrl,
        width: 24,
        height: 24,
        errorBuilder: (c, e, s) =>
            const Icon(Icons.credit_card, color: Colors.grey),
      );
    } else {
      IconData iconData = Icons.credit_card;
      Color color = Colors.grey;
      if (name.toLowerCase().contains('gopay')) {
        iconData = Icons.account_balance_wallet;
        color = Colors.green;
      } else if (name.toLowerCase().contains('ovo')) {
        iconData = Icons.monetization_on;
        color = Colors.purple;
      } else if (name.toLowerCase().contains('bca') ||
          name.toLowerCase().contains('bank')) {
        iconData = Icons.account_balance;
        color = Colors.blue;
      }

      iconWidget = Icon(iconData, color: color, size: 24);
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
            child: iconWidget,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currencyFormat.format(balance),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
            onPressed: () => _deleteMethod(id, 0),
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

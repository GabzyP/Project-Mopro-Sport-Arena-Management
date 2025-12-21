import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok6_sportareamanagement/models/venue_model.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';
import 'package:kelompok6_sportareamanagement/screens/profile/payment_method_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Field field;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String bookingId;
  final String bookingCode;
  final double totalPrice;

  const PaymentScreen({
    Key? key,
    required this.field,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookingId,
    required this.bookingCode,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = true;
  bool isProcessing = false;

  List<dynamic> availableMethods = [];
  Map<String, dynamic>? selectedMethod;

  double adminFee = 0;
  double grandTotal = 0;
  int durationInHours = 1;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _calculateDuration();
    _fetchPaymentMethods();
  }

  void _calculateDuration() {
    try {
      int start = int.parse(widget.startTime.split(':')[0]);
      int end = int.parse(widget.endTime.split(':')[0]);
      durationInHours = end - start;
      if (durationInHours < 1) durationInHours = 1;
    } catch (e) {
      durationInHours = 1;
    }
  }

  Future<void> _fetchPaymentMethods() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('userId');

      if (uid != null) {
        final methods = await ApiService.getSavedPaymentMethods(uid);
        if (mounted) {
          setState(() {
            availableMethods = methods;
            isLoading = false;

            if (selectedMethod != null) {
              try {
                selectedMethod = methods.firstWhere(
                  (m) => m['id'].toString() == selectedMethod!['id'].toString(),
                );
              } catch (_) {
                selectedMethod = null;
              }
            } else if (methods.isNotEmpty) {
              selectedMethod = methods.first;
            }
            _updateTotal();
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching methods: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _updateTotal() {
    double fieldPrice = widget.totalPrice;

    if (selectedMethod != null) {
      String type = (selectedMethod!['type'] ?? '').toString().toLowerCase();
      if (type.contains('bank') || type.contains('va')) {
        adminFee = 2500;
      } else {
        adminFee = 0;
      }
    } else {
      adminFee = 0;
    }
    grandTotal = fieldPrice + adminFee;
  }

  void _showTopUpDialog(Map<String, dynamic> method) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Top Up ${method['name']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Saldo saat ini: ${currencyFormat.format(double.tryParse(method['balance'].toString()) ?? 0)}",
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nominal Top Up",
                hintText: "Contoh: 50000",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              double? amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(ctx);
                await _processTopUp(method['id'].toString(), amount);
              }
            },
            child: const Text("Top Up"),
          ),
        ],
      ),
    );
  }

  Future<void> _processTopUp(String methodId, double amount) async {
    setState(() => isLoading = true);
    try {
      await ApiService.topUpBalance(methodId: methodId, amount: amount);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Top Up Berhasil!")));
      _fetchPaymentMethods();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal Top Up: $e")));
    }
  }

  void _handlePayment() async {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran dulu!")),
      );
      return;
    }

    double currentBalance =
        double.tryParse(selectedMethod!['balance'].toString()) ?? 0;

    if (currentBalance < grandTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saldo tidak cukup! Silakan Top Up."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isProcessing = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    final result = await ApiService.payBooking(
      bookingId: widget.bookingId,
      userId: userId,
      paymentMethodId: selectedMethod!['id'].toString(),
    );

    if (mounted) {
      setState(() => isProcessing = false);
      if (result['status'] == 'success') {
        _showSuccessDialog(widget.bookingCode);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal: ${result['message']}")));
      }
    }
  }

  void _showSuccessDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Pembayaran Lunas!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Kode: $code",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan cek menu Riwayat.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            },
            child: const Text(
              "Lihat Riwayat",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method) {
    bool isSelected =
        selectedMethod != null &&
        selectedMethod!['id'].toString() == method['id'].toString();
    String name = method['name'] ?? 'Unknown';
    double balance = double.tryParse(method['balance'].toString()) ?? 0;
    String imgUrl = method['image_url'] ?? '';

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
      String type = (method['type'] ?? '').toString().toLowerCase();

      if (name.toLowerCase().contains('gopay')) {
        iconData = Icons.account_balance_wallet;
        color = Colors.green;
      } else if (name.toLowerCase().contains('ovo')) {
        iconData = Icons.monetization_on;
        color = Colors.purple;
      } else if (type.contains('bank') || type.contains('va')) {
        iconData = Icons.account_balance;
        color = Colors.blue;
      }
      iconWidget = Icon(iconData, color: color);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
          _updateTotal();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.green, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
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
                  Text(
                    "Saldo: ${currencyFormat.format(balance)}",
                    style: TextStyle(
                      color: balance >= grandTotal
                          ? Colors.grey
                          : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _showTopUpDialog(method),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "+ Top Up",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                ),
                color: isSelected ? Colors.green : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Konfirmasi Pembayaran",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(),
            const SizedBox(height: 20),
            _buildCostCard(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodScreen(),
                      ),
                    );
                    _fetchPaymentMethods();
                  },
                  child: const Text(
                    "Kelola / Tambah",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (availableMethods.isEmpty)
              _buildEmptyMethodState()
            else
              Column(
                children: availableMethods
                    .map((method) => _buildPaymentMethodItem(method))
                    .toList(),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _rowInfo("Lapangan", widget.field.name),
          const Divider(height: 24),
          _rowInfo(
            "Tanggal",
            DateFormat('dd MMM yyyy', 'id_ID').format(widget.date),
          ),
          const Divider(height: 24),
          _rowInfo("Jam", "${widget.startTime} - ${widget.endTime}"),
          const Divider(height: 24),
          _rowInfo("Durasi", "$durationInHours Jam"),
        ],
      ),
    );
  }

  Widget _buildCostCard() {
    double originalPrice = widget.field.pricePerHour * durationInHours;
    double finalPrice = widget.totalPrice;
    double discount = originalPrice - finalPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _rowInfo("Harga Sewa Normal", currencyFormat.format(originalPrice)),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _rowInfo(
              "Diskon",
              "- ${currencyFormat.format(discount)}",
              color: Colors.red,
            ),
          ],
          const SizedBox(height: 12),
          _rowInfo(
            "Biaya Layanan",
            currencyFormat.format(adminFee),
            isHighlighted: true,
          ),
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormat.format(grandTotal),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMethodState() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          Icon(Icons.credit_card_off, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Belum ada metode pembayaran.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(
    String label,
    String value, {
    bool isHighlighted = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? (isHighlighted ? Colors.orange : Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Tagihan",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                currencyFormat.format(grandTotal),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: isProcessing ? null : _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Bayar Sekarang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

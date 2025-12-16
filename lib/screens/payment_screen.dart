import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import 'main_layout.dart';

class PaymentScreen extends StatefulWidget {
  final Field field;
  final String venueName;
  final DateTime date;
  final List<String> slots;

  const PaymentScreen({
    super.key,
    required this.field,
    required this.venueName,
    required this.date,
    required this.slots,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int currentStep = 1;
  String? selectedPaymentMethod;
  bool isRecurring = false;
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF22c55e);
  final Color infoBgColor = const Color(0xFFF9FAFB);
  final Color recurringBgColor = const Color(0xFFF0FDF4);

  // --- DATA METODE PEMBAYARAN ---
  final List<Map<String, dynamic>> eWallets = [
    {
      'id': 'gopay',
      'name': 'GoPay',
      'icon': Icons.account_balance_wallet,
      'color': Colors.blue,
      'fee': 0,
    },
    {
      'id': 'ovo',
      'name': 'OVO',
      'icon': Icons.monetization_on,
      'color': Colors.purple,
      'fee': 0,
    },
    {
      'id': 'dana',
      'name': 'DANA',
      'icon': Icons.attach_money,
      'color': Colors.blueAccent,
      'fee': 0,
    },
  ];

  final List<Map<String, dynamic>> banks = [
    {'id': 'bca', 'name': 'BCA Virtual Account', 'fee': 4000},
    {'id': 'bni', 'name': 'BNI Virtual Account', 'fee': 4000},
    {'id': 'mandiri', 'name': 'Mandiri Virtual Account', 'fee': 4000},
  ];

  // --- LOGIKA HARGA ---
  double get totalPrice => widget.field.pricePerHour * widget.slots.length;

  double get paymentFee {
    if (selectedPaymentMethod == null) return 0;

    // Cek di E-Wallet
    var wallet = eWallets.firstWhere(
      (e) => e['id'] == selectedPaymentMethod,
      orElse: () => {},
    );
    if (wallet.isNotEmpty) return (wallet['fee'] as int).toDouble();

    // Cek di Bank
    var bank = banks.firstWhere(
      (b) => b['id'] == selectedPaymentMethod,
      orElse: () => {},
    );
    if (bank.isNotEmpty) return (bank['fee'] as int).toDouble();

    return 0;
  }

  double get grandTotal => totalPrice + paymentFee;

  String formatRupiah(double number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  void _handlePayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran dulu")),
      );
      return;
    }

    setState(() => isLoading = true);

    // Kirim data ke API
    final result = await ApiService.createBooking(
      fieldId: widget.field.id,
      date: DateFormat('yyyy-MM-dd').format(widget.date),
      slots: widget.slots,
      totalPrice: grandTotal,
    );

    setState(() => isLoading = false);

    if (result['status'] == 'success') {
      _showSuccessDialog(result['booking_code']);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }

  void _showSuccessDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text("Kode Booking: $code"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                  (route) => false,
                ),
                child: const Text(
                  "Kembali ke Beranda",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentStep == 1 ? "Konfirmasi Booking" : "Pembayaran",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Langkah $currentStep dari 2",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (currentStep == 2)
              setState(() => currentStep = 1);
            else
              Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Row(
            children: [
              Expanded(child: Container(height: 3, color: primaryColor)),
              Expanded(
                child: Container(
                  height: 3,
                  color: currentStep == 2 ? primaryColor : Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
      ),
      body: currentStep == 1 ? _buildStep1() : _buildStep2(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // --- STEP 1: REVIEW ---
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detail Booking",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // Card Detail
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.field.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.field.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.venueName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: infoBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _infoRow(
                        Icons.calendar_today_outlined,
                        DateFormat(
                          "EEEE, d MMMM yyyy",
                          "id_ID",
                        ).format(widget.date),
                      ),
                      const SizedBox(height: 10),
                      _infoRow(Icons.access_time, widget.slots.join(", ")),
                      const SizedBox(height: 10),
                      _infoRow(
                        Icons.location_on_outlined,
                        "Akan ditampilkan lokasi venue",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Booking Berkala Toggle
          GestureDetector(
            onTap: () => setState(() => isRecurring = !isRecurring),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isRecurring ? recurringBgColor : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isRecurring ? primaryColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.sync, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Booking Berkala",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Jadwal berulang setiap minggu",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecurring ? primaryColor : Colors.white,
                      border: Border.all(
                        color: isRecurring ? primaryColor : Colors.grey[400]!,
                      ),
                    ),
                    child: isRecurring
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Rincian Harga
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _priceRow(
                  "${widget.field.name} x ${widget.slots.length} jam",
                  totalPrice,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Biaya Layanan",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const Text(
                      "Gratis",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _priceRow("Total", totalPrice, isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // --- STEP 2: PAYMENT ---
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "E-Wallet",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: eWallets.length,
            itemBuilder: (context, index) {
              final wallet = eWallets[index];
              bool isSelected = selectedPaymentMethod == wallet['id'];
              return GestureDetector(
                onTap: () =>
                    setState(() => selectedPaymentMethod = wallet['id']),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: primaryColor, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(wallet['icon'], color: wallet['color']),
                      const SizedBox(width: 8),
                      Text(
                        wallet['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Transfer Bank",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ...banks.map((bank) {
            bool isSelected = selectedPaymentMethod == bank['id'];
            return GestureDetector(
              onTap: () => setState(() => selectedPaymentMethod = bank['id']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: primaryColor, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bank['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "+${formatRupiah((bank['fee'] as int).toDouble())}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: Color(0xFF22c55e)),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentStep == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal", style: TextStyle(color: Colors.grey)),
                  Text(formatRupiah(totalPrice)),
                ],
              ),
              if (paymentFee > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Biaya Admin",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(formatRupiah(paymentFee)),
                    ],
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Bayar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    formatRupiah(grandTotal),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (currentStep == 1)
                    setState(() => currentStep = 2);
                  else
                    _handlePayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        currentStep == 1
                            ? "Pilih Pembayaran"
                            : "Bayar Sekarang",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryColor, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
            fontSize: isTotal ? 16 : 13,
          ),
        ),
        Text(
          formatRupiah(value),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16 : 13,
            color: isTotal ? primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }
}

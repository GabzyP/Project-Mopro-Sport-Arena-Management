import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLoadingMethods = true;

  final Color primaryColor = const Color(0xFF22c55e);
  final Color infoBgColor = const Color(0xFFF9FAFB);
  final Color recurringBgColor = const Color(0xFFF0FDF4);

  // Variabel untuk menampung data dari database
  List<Map<String, dynamic>> eWallets = [];
  List<Map<String, dynamic>> banks = [];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethodsFromDb();
  }

  // --- FITUR: Ambil data metode pembayaran asli dari database ---
  Future<void> _loadPaymentMethodsFromDb() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId'); // Ini akan mengambil ID 32

    if (userId != null) {
      final data = await ApiService.getSavedPaymentMethods(userId);
      if (mounted) {
        setState(() {
          eWallets = [];
          banks = [];
          for (var item in data) {
            // Mapping icon dan warna berdasarkan nama agar tampilan tetap bagus
            IconData icon = Icons.credit_card;
            Color color = Colors.grey;
            double fee = (item['type'] == 'bank') ? 4000 : 0;

            if (item['name'].toString().toLowerCase().contains('gopay')) {
              icon = Icons.account_balance_wallet;
              color = Colors.blue;
            } else if (item['name'].toString().toLowerCase().contains('ovo')) {
              icon = Icons.monetization_on;
              color = Colors.purple;
            } else if (item['name'].toString().toLowerCase().contains('dana')) {
              icon = Icons.attach_money;
              color = Colors.blueAccent;
            }

            final method = {
              'id': item['id'].toString(),
              'name': item['name'],
              'detail': item['detail'],
              'icon': icon,
              'color': color,
              'fee': fee,
            };

            if (item['type'] == 'wallet' || item['type'] == 'ewallet') {
              eWallets.add(method);
            } else {
              banks.add(method);
            }

            // Set default jika ada yang ditandai sebagai utama
            if (item['is_default'] == '1') {
              selectedPaymentMethod = item['id'].toString();
            }
          }
          isLoadingMethods = false;
        });
      }
    }
  }

  double get totalPrice => widget.field.pricePerHour * widget.slots.length;

  double get paymentFee {
    if (selectedPaymentMethod == null) return 0;

    var wallet = eWallets.firstWhere(
      (e) => e['id'] == selectedPaymentMethod,
      orElse: () => {},
    );
    if (wallet.isNotEmpty) return (wallet['fee'] as double);

    var bank = banks.firstWhere(
      (b) => b['id'] == selectedPaymentMethod,
      orElse: () => {},
    );
    if (bank.isNotEmpty) return (bank['fee'] as double);

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

  void _showAddMethodDialog() {
    final TextEditingController nameController = TextEditingController();
    String type = 'E-Wallet';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Tambah Metode Baru"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: type,
                    items: ['E-Wallet', 'Bank']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setStateDialog(() => type = val!),
                    decoration: const InputDecoration(labelText: "Tipe"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Metode",
                      hintText: "Contoh: ShopeePay",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        final newItem = {
                          'id': nameController.text.toLowerCase().replaceAll(
                            ' ',
                            '',
                          ),
                          'name': nameController.text,
                          'icon': type == 'E-Wallet'
                              ? Icons.account_balance_wallet
                              : Icons.account_balance,
                          'color': Colors.grey,
                          'fee': type == 'E-Wallet' ? 0.0 : 4000.0,
                        };
                        if (type == 'E-Wallet') {
                          eWallets.add(newItem);
                        } else {
                          banks.add(newItem);
                        }
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handlePayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran dulu")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      List<String> sortedSlots = List.from(widget.slots)..sort();
      String startTime = sortedSlots.first;
      DateTime lastTimeDt = DateFormat("HH:mm").parse(sortedSlots.last);
      String endTime = DateFormat(
        "HH:mm",
      ).format(lastTimeDt.add(const Duration(hours: 1)));

      // Ambil nama metode untuk dikirim ke DB
      String methodName = "";
      var all = [...eWallets, ...banks];
      var selected = all.firstWhere((m) => m['id'] == selectedPaymentMethod);
      methodName = selected['name'];

      final result = await ApiService.createBooking(
        userId: userId!,
        fieldId: widget.field.id,
        date: DateFormat('yyyy-MM-dd').format(widget.date),
        startTime: startTime,
        endTime: endTime,
        totalPrice: grandTotal,
        paymentMethod: methodName,
      );

      if (mounted) setState(() => isLoading = false);

      if (result['status'] == 'success') {
        _showSuccessDialog(result['booking_code'] ?? "BERHASIL");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Gagal booking")),
        );
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => currentStep == 2
              ? setState(() => currentStep = 1)
              : Navigator.pop(context),
        ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
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
                        errorBuilder: (_, __, ___) => Container(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                  const Icon(Icons.sync, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Booking Berkala",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isRecurring)
                    Icon(Icons.check_circle, color: primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    if (isLoadingMethods)
      return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _showAddMethodDialog,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Metode Pembayaran"),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                    const Icon(Icons.account_balance, color: Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        bank['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: primaryColor),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
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
                onPressed: () => currentStep == 1
                    ? setState(() => currentStep = 2)
                    : _handlePayment(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 18),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

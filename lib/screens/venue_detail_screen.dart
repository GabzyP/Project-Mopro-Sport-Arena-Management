import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import 'payment_screen.dart';

class VenueDetailScreen extends StatefulWidget {
  final Venue venue;
  const VenueDetailScreen({super.key, required this.venue});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  List<Field> fields = [];
  Field? selectedField;
  DateTime selectedDate = DateTime.now();
  Map<String, dynamic> bookedSlots = {};
  List<String> userSelectedSlots = [];
  bool isLoading = true;
  bool isSlotLoading = false;
  bool isLiked = false;

  final Color primaryColor = const Color(0xFF22c55e);
  final Color bgColor = const Color(0xFFf9fafb);

  int _userPoints = 0;
  double _discountPercent = 0.0;
  List<dynamic> myRewards = [];
  Map<String, dynamic>? selectedReward;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadUserData();
      _loadFields();
      _checkFavorite();
      _loadUserData();
      _loadFields();
      _checkFavorite();
      _loadRewards();
    });
  }

  Future<void> _loadRewards() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final rewards = await ApiService.getMyRewards(userId);
      if (mounted) {
        setState(() {
          myRewards = rewards;
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final details = await ApiService.getUserDetails(userId);
      if (mounted) {
        setState(() {
          _userPoints = int.tryParse(details['points'].toString()) ?? 0;
          _calculateDiscount();
        });
      }
    }
  }

  void _calculateDiscount() {
    if (_userPoints >= 1000000) {
      _discountPercent = 0.20;
    } else if (_userPoints >= 100000) {
      _discountPercent = 0.20;
    } else if (_userPoints >= 10000) {
      _discountPercent = 0.15;
    } else if (_userPoints >= 2000) {
      _discountPercent = 0.10;
    } else if (_userPoints >= 500) {
      _discountPercent = 0.05;
    } else {
      _discountPercent = 0.0;
    }
  }

  Future<void> _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final status = await ApiService.checkFavorite(userId, widget.venue.id);
      if (mounted) {
        setState(() {
          isLiked = status;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return;

    final result = await ApiService.toggleFavorite(userId, widget.venue.id);

    if (mounted) {
      if (result['status'] == 'success') {
        setState(() {
          isLiked = result['is_favorite'] == true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    }
  }

  Future<void> _loadFields() async {
    try {
      final data = await ApiService.getFields(widget.venue.id);
      if (mounted) {
        setState(() {
          fields = data;
          isLoading = false;
          if (fields.isNotEmpty) {
            selectedField = fields[0];
            _checkSlots();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
      }
    }
  }

  Future<void> _checkSlots() async {
    if (selectedField == null) return;
    setState(() {
      isSlotLoading = true;
      userSelectedSlots.clear();
      bookedSlots = {};
    });

    try {
      String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      final slots = await ApiService.checkAvailability(
        selectedField!.id,
        dateStr,
      );
      if (mounted) {
        setState(() {
          bookedSlots = slots;
          isSlotLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isSlotLoading = false);
    }
  }

  List<String> _generateTimeSlots() {
    int startHour = 8;
    int endHour = 22;

    try {
      if (widget.venue.openTime.isNotEmpty) {
        final parts = widget.venue.openTime.split(':');
        if (parts.isNotEmpty) {
          startHour = int.parse(parts[0]);
        }
      }

      if (widget.venue.closeTime.isNotEmpty) {
        final parts = widget.venue.closeTime.split(':');
        if (parts.isNotEmpty) {
          endHour = int.parse(parts[0]);
        }
      }

      if (endHour == 0) endHour = 24;

      if (endHour <= startHour) {
        startHour = 8;
        endHour = 22;
      }
    } catch (e) {
      startHour = 8;
      endHour = 22;
    }

    List<String> slots = [];
    for (int i = startHour; i < endHour; i++) {
      slots.add("${i.toString().padLeft(2, '0')}:00");
    }
    return slots;
  }

  String formatRupiah(double number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  double get originalTotalPrice {
    if (selectedField == null) return 0;
    return selectedField!.pricePerHour * userSelectedSlots.length;
  }

  double get totalPrice {
    double price = originalTotalPrice * (1 - _discountPercent);

    if (selectedReward != null) {
      String title = selectedReward!['reward_title'].toString().toLowerCase();
      if (title.contains('voucher') && title.contains('50.000')) {
        price -= 50000;
      } else if (title.contains('free booking') && selectedField != null) {
        price -= selectedField!.pricePerHour;
      }
    }

    return price < 0 ? 0 : price;
  }

  void _navigateToPayment() async {
    if (userSelectedSlots.isEmpty) return;

    setState(() => isSlotLoading = true);

    userSelectedSlots.sort();
    String startTime = userSelectedSlots.first;
    String lastSlot = userSelectedSlots.last;
    int lastHour = int.parse(lastSlot.split(':')[0]);
    String endTime = "${(lastHour + 1).toString().padLeft(2, '0')}:00";

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

    try {
      final result = await ApiService.lockBooking(
        userId: userId,
        fieldId: selectedField!.id,
        date: DateFormat('yyyy-MM-dd').format(selectedDate),
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        rewardId: selectedReward?['id'].toString(),
      );

      setState(() => isSlotLoading = false);

      if (result['status'] == 'success') {
        String bookingId = result['booking_id'].toString();
        String bookingCode = result['booking_code'].toString();
        double finalPrice =
            double.tryParse(result['total_price'].toString()) ?? totalPrice;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              field: selectedField!,
              date: selectedDate,
              startTime: startTime,
              endTime: endTime,
              bookingId: bookingId,
              bookingCode: bookingCode,
              totalPrice: finalPrice,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      setState(() => isSlotLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: primaryColor,
                leading: _buildCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                actions: [
                  _buildCircleButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                    onTap: _toggleFavorite,
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.venue.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade300),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.venue.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${widget.venue.openTime} - ${widget.venue.closeTime}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Lapangan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (fields.isEmpty)
                        const Text("Belum ada lapangan tersedia.")
                      else
                        ...fields.map((field) => _buildFieldCard(field)),

                      const SizedBox(height: 20),
                      if (selectedField != null) ...[
                        const Text(
                          "Pilih Tanggal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDatePicker(),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildLegendItem(
                              Colors.white,
                              "Tersedia",
                              border: true,
                            ),
                            _buildLegendItem(Colors.amber.shade100, "Diproses"),
                            _buildLegendItem(Colors.red.shade100, "Terpesan"),
                            _buildLegendItem(
                              primaryColor,
                              "Dipilih",
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pilih Waktu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        isSlotLoading
                            ? const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _buildTimeGrid(),
                        const SizedBox(height: 20),
                        if (myRewards.isNotEmpty) ...[
                          const Text(
                            "Gunakan Reward",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  "Pilih reward...",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                value: selectedReward?['id']?.toString(),
                                dropdownColor: Theme.of(context).cardColor,
                                items: myRewards.map<DropdownMenuItem<String>>((
                                  r,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: r['id'].toString(),
                                    child: Text(
                                      r['reward_title'],
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == null) {
                                      selectedReward = null;
                                    } else {
                                      selectedReward = myRewards.firstWhere(
                                        (r) => r['id'].toString() == val,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          if (selectedReward != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Reward diterapkan",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () =>
                                        setState(() => selectedReward = null),
                                    child: const Text(
                                      "Hapus",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (selectedField != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total (${userSelectedSlots.length} jam)",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_discountPercent > 0)
                          Text(
                            formatRupiah(originalTotalPrice),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          formatRupiah(totalPrice),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: userSelectedSlots.isEmpty
                          ? null
                          : _navigateToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Lanjut Pembayaran",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFieldCard(Field field) {
    bool isSelected = selectedField?.id == field.id;
    return GestureDetector(
      onTap: () {
        if (selectedField?.id != field.id) {
          setState(() => selectedField = field);
          _checkSlots();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: primaryColor, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                field.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(width: 70, height: 70, color: Colors.grey[200]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      field.sportType,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blueGrey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${formatRupiah(field.pricePerHour)}/jam",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected =
              date.day == selectedDate.day && date.month == selectedDate.month;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => selectedDate = date);
                _checkSlots();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE', 'id_ID').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${date.day}",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM', 'id_ID').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegendItem(
    Color color,
    String label, {
    bool border = false,
    Color textColor = Colors.black,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: border ? Border.all(color: Colors.grey[300]!) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeGrid() {
    List<String> timeSlots = _generateTimeSlots();
    if (timeSlots.isEmpty)
      return const Center(child: Text("Jadwal operasional tidak tersedia"));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        String timeLabel = timeSlots[index];
        String status = bookedSlots[timeLabel] ?? 'available';
        bool isSelected = userSelectedSlots.contains(timeLabel);

        Color bgColor;
        Color txtColor;
        bool isClickable = false;

        if (status == 'booked') {
          bgColor = Colors.red.shade100;
          txtColor = Colors.red;
        } else if (status == 'locked') {
          bgColor = Colors.amber.shade100;
          txtColor = Colors.amber[800]!;
        } else if (isSelected) {
          bgColor = primaryColor;
          txtColor = Colors.white;
          isClickable = true;
        } else {
          bgColor = Theme.of(context).cardColor;
          txtColor =
              Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
          isClickable = true;
        }

        return GestureDetector(
          onTap: () {
            if (!isClickable) return;
            setState(() {
              isSelected
                  ? userSelectedSlots.remove(timeLabel)
                  : userSelectedSlots.add(timeLabel);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey[300]!,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              timeLabel,
              style: TextStyle(
                color: txtColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

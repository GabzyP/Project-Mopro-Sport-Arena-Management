import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:kelompok6_sportareamanagement/models/booking_model.dart';
import 'package:kelompok6_sportareamanagement/models/venue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';
import 'package:kelompok6_sportareamanagement/screens/booking/payment_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Color brownColor = const Color(0xFF4E342E);
  final Color brownGradient = const Color(0xFF3E2723);

  String selectedFilter = 'all';
  List<Booking> allBookings = [];
  bool isLoading = true;
  Timer? _refreshTimer;

  bool _isPast(Booking b) {
    try {
      final dateParts = b.date.split('-');
      final timeParts = b.endTime.split(':');
      final endDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      return endDateTime.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  bool _isActivePeriod(Booking b) {
    try {
      final dateParts = b.date.split('-');
      final timeParts = b.endTime.split(':');
      final endDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      return endDateTime.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  String formatRupiah(double number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  @override
  void initState() {
    super.initState();
    _loadBookings();

    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadBookings();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');

    if (uid != null) {
      final dynamicData = await ApiService.getUserBookings(uid);

      if (mounted) {
        setState(() {
          allBookings = List.from(
            dynamicData,
          ).map((item) => Booking.fromJson(item)).toList();
          isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _resumePayment(Booking booking) {
    Field dummyField = Field(
      id: booking.fieldId,
      name: booking.fieldName,
      sportType: 'General',
      pricePerHour: 0,
      imageUrl: '',
      facilities: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          field: dummyField,
          date: DateTime.parse(booking.date),
          startTime: booking.startTime,
          endTime: booking.endTime,
          bookingId: booking.id,
          bookingCode: booking.bookingCode,
          totalPrice: booking.totalPrice,
        ),
      ),
    ).then((_) => _loadBookings());
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> displayedBookings = [];
    final now = DateTime.now();

    Map<String, List<Booking>> dayFieldGroups = {};
    for (var b in allBookings) {
      String key = "${b.fieldId}_${b.date}";
      if (!dayFieldGroups.containsKey(key)) {
        dayFieldGroups[key] = [];
      }
      dayFieldGroups[key]!.add(b);
    }

    List<Booking> cleanedBookings = [];

    int getPriority(String status) {
      switch (status) {
        case 'booked':
          return 5;
        case 'confirmed':
          return 5;
        case 'processing':
          return 4;
        case 'locked':
          return 3;
        case 'unpaid':
          return 3;
        case 'pending':
          return 3;
        case 'completed':
          return 2;
        case 'cancelled':
          return 1;
        default:
          return 0;
      }
    }

    dayFieldGroups.forEach((key, daySlots) {
      daySlots.sort((a, b) {
        int priorityA = getPriority(a.status);
        int priorityB = getPriority(b.status);
        if (priorityA != priorityB) return priorityB.compareTo(priorityA);
        return b.id.compareTo(a.id);
      });

      List<Booking> acceptedForDay = [];

      for (var candidate in daySlots) {
        if (candidate.startTime.isEmpty || candidate.endTime.isEmpty) continue;

        double startC =
            double.parse(candidate.startTime.split(':')[0]) +
            double.parse(candidate.startTime.split(':')[1]) / 60.0;
        double endC =
            double.parse(candidate.endTime.split(':')[0]) +
            double.parse(candidate.endTime.split(':')[1]) / 60.0;

        bool hasOverlap = false;
        for (var accepted in acceptedForDay) {
          double startA =
              double.parse(accepted.startTime.split(':')[0]) +
              double.parse(accepted.startTime.split(':')[1]) / 60.0;
          double endA =
              double.parse(accepted.endTime.split(':')[0]) +
              double.parse(accepted.endTime.split(':')[1]) / 60.0;

          if (startC < endA && endC > startA) {
            hasOverlap = true;
            break;
          }
        }

        if (!hasOverlap) {
          acceptedForDay.add(candidate);
        }
      }

      cleanedBookings.addAll(acceptedForDay);
    });
    for (var b in cleanedBookings) {
      DateTime? bookingEnd;
      try {
        final dateParts = b.date.split('-');
        final timeParts = b.endTime.split(':');
        bookingEnd = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } catch (e) {
        bookingEnd = null;
      }

      bool isPast = bookingEnd != null && bookingEnd.isBefore(now);
      bool isActivePeriod = bookingEnd != null && bookingEnd.isAfter(now);

      if ((b.status == 'locked' ||
              b.status == 'unpaid' ||
              b.status == 'pending') &&
          isPast) {
        continue;
      }

      if (selectedFilter == 'all') {
        displayedBookings.add(b);
      } else if (selectedFilter == 'unpaid') {
        if (b.status == 'locked' ||
            b.status == 'unpaid' ||
            b.status == 'pending') {
          displayedBookings.add(b);
        }
      } else if (selectedFilter == 'processing') {
        if (b.status == 'processing') {
          displayedBookings.add(b);
        }
      } else if (selectedFilter == 'active') {
        if ((b.status == 'booked' || b.status == 'confirmed') &&
            isActivePeriod) {
          displayedBookings.add(b);
        }
      } else if (selectedFilter == 'completed') {
        if (b.status == 'completed' ||
            b.status == 'cancelled' ||
            ((b.status == 'booked' || b.status == 'confirmed') && isPast)) {
          displayedBookings.add(b);
        }
      }
    }

    displayedBookings.sort((a, b) {
      DateTime? timeA;
      DateTime? timeB;
      try {
        final dateA = a.date.split('-');
        final timeAParts = a.startTime.split(':');
        timeA = DateTime(
          int.parse(dateA[0]),
          int.parse(dateA[1]),
          int.parse(dateA[2]),
          int.parse(timeAParts[0]),
          int.parse(timeAParts[1]),
        );

        final dateB = b.date.split('-');
        final timeBParts = b.startTime.split(':');
        timeB = DateTime(
          int.parse(dateB[0]),
          int.parse(dateB[1]),
          int.parse(dateB[2]),
          int.parse(timeBParts[0]),
          int.parse(timeBParts[1]),
        );
      } catch (_) {
        return 0;
      }

      bool isPastA = timeA.isBefore(now);
      bool isPastB = timeB.isBefore(now);

      if (isPastA != isPastB) {
        return isPastA ? 1 : -1;
      }

      if (!isPastA) {
        return timeA.compareTo(timeB);
      } else {
        return timeB.compareTo(timeA);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _loadBookings,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 24,
                  right: 24,
                  bottom: 40,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [brownColor, brownGradient]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Booking Saya",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _loadBookings,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          tooltip: "Refresh Data",
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kelola semua reservasi lapangan Anda",
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _statCard(
                        displayedBookings.length.toString(),
                        "Tampil",
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        cleanedBookings
                            .where(
                              (b) =>
                                  (b.status == 'booked' ||
                                      b.status == 'confirmed') &&
                                  _isActivePeriod(b),
                            )
                            .length
                            .toString(),
                        "Aktif",
                        Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        cleanedBookings
                            .where((b) {
                              bool isPast = _isPast(b);
                              return b.status == 'completed' ||
                                  b.status == 'cancelled' ||
                                  ((b.status == 'booked' ||
                                          b.status == 'confirmed') &&
                                      isPast);
                            })
                            .length
                            .toString(),
                        "Selesai",
                        Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _filterChip('all', 'Semua'),
                    _filterChip('active', 'Aktif'),
                    _filterChip('processing', 'Menunggu Konfirmasi'),
                    _filterChip('unpaid', 'Belum Bayar'),
                    _filterChip('completed', 'Selesai'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (displayedBookings.isNotEmpty)
                        ...displayedBookings.map((b) => _bookingCard(b)),
                      if (displayedBookings.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text("Tidak ada booking"),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String id, String label) {
    bool isSelected = selectedFilter == id;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = id),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4E342E)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _bookingCard(Booking booking) {
    Color statusColor = Colors.grey;
    String statusText = booking.status;
    IconData statusIcon = Icons.info;
    bool isActive = false;

    bool isPast = _isPast(booking);

    if (booking.status == 'locked' ||
        booking.status == 'unpaid' ||
        booking.status == 'pending') {
      statusColor = Colors.orange;
      statusText = "Belum Bayar";
      statusIcon = Icons.timer;
      isActive = true;
    } else if (booking.status == 'processing') {
      statusColor = Colors.blue;
      statusText = "Menunggu Konfirmasi";
      statusIcon = Icons.hourglass_top;
      isActive = true;
    } else if (booking.status == 'cancelled') {
      statusColor = Colors.red;
      statusText = "Dibatalkan";
      statusIcon = Icons.cancel;
    } else if (booking.status == 'completed' ||
        (isPast &&
            (booking.status == 'booked' || booking.status == 'confirmed'))) {
      statusColor = Colors.grey;
      statusText = "Selesai";
      statusIcon = Icons.history;
    } else if (booking.status == 'booked' || booking.status == 'confirmed') {
      statusColor = Colors.green;
      statusText = "Pemesanan Berhasil";
      statusIcon = Icons.check_circle;
      isActive = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isActive
            ? statusColor.withOpacity(0.05)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: statusColor.withOpacity(0.5), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID: ${booking.bookingCode}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: brownColor.withOpacity(0.6),
                        letterSpacing: 1.1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 12, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  booking.fieldName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  booking.venueName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      booking.date,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${booking.startTime} - ${booking.endTime}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),

                if (booking.status == 'completed' ||
                    (booking.status == 'booked' && _isPast(booking)))
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.star_rate_rounded, size: 18),
                        label: const Text("Beri Ulasan"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showReviewDialog(booking),
                      ),
                    ),
                  ),

                if (booking.status == 'locked' ||
                    booking.status == 'unpaid' ||
                    booking.status == 'pending') ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _resumePayment(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Bayar Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Selesaikan pembayaran segera.",
                      style: TextStyle(fontSize: 10, color: Colors.redAccent),
                    ),
                  ),
                ] else if (booking.status == 'processing') ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_top, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Menunggu Konfirmasi Admin",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (booking.status == 'booked' ||
                    booking.status == 'confirmed') ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Tunjukkan tiket ini di lokasi",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatRupiah(booking.totalPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(Booking booking) {
    int rating = 0;
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Beri Ulasan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.venueName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    booking.fieldName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Rating Anda:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: "Tulis pengalaman Anda...",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mohon pilih bintang")),
                      );
                      return;
                    }

                    final prefs = await SharedPreferences.getInstance();
                    final userId = prefs.getString('userId');
                    if (userId == null) return;

                    Navigator.pop(context);

                    final result = await ApiService.addReview(
                      userId: userId,
                      venueName: booking.venueName,
                      sportType: booking.fieldName,
                      rating: rating,
                      comment: commentController.text,
                      bookingId: booking.id,
                    );

                    if (mounted) {
                      if (result['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Terima kasih! Ulasan terkirim."),
                          ),
                        );
                        _loadBookings();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['message'] ?? "Gagal mengirim",
                            ),
                          ),
                        );
                      }
                    }
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
}

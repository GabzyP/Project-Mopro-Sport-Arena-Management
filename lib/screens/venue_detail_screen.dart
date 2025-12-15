import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';

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
  bool isLiked = false;

  final Color primaryColor = const Color(0xFF22c55e);

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  void _loadFields() async {
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
  }

  void _checkSlots() async {
    if (selectedField == null) return;
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final slots = await ApiService.checkAvailability(
      selectedField!.id,
      dateStr,
    );
    if (mounted) {
      setState(() {
        bookedSlots = slots;
        userSelectedSlots.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.venue.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey),
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
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                widget.venue.name,
                style: const TextStyle(color: Colors.white),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (fields.isEmpty)
                    const Text("Tidak ada lapangan tersedia")
                  else
                    ...fields.map((field) => _buildFieldItem(field)),

                  const SizedBox(height: 20),
                  if (selectedField != null) ...[
                    Text(
                      "Jadwal - ${selectedField!.name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTimeGrid(),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(Field field) {
    bool isSelected = selectedField?.id == field.id;
    return GestureDetector(
      onTap: () {
        setState(() => selectedField = field);
        _checkSlots();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: isSelected ? Border.all(color: primaryColor, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                field.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "Rp ${field.pricePerHour}",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        int hour = 8 + index;
        String timeLabel = "${hour.toString().padLeft(2, '0')}:00";
        String status = bookedSlots[timeLabel] ?? 'available';
        bool isSelected = userSelectedSlots.contains(timeLabel);

        Color bgColor = status == 'booked'
            ? Colors.red[100]!
            : (isSelected ? primaryColor : Colors.white);
        Color txtColor = status == 'booked'
            ? Colors.red
            : (isSelected ? Colors.white : Colors.black);

        return GestureDetector(
          onTap: () {
            if (status != 'available') return;
            setState(() {
              if (isSelected)
                userSelectedSlots.remove(timeLabel);
              else
                userSelectedSlots.add(timeLabel);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            alignment: Alignment.center,
            child: Text(
              timeLabel,
              style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

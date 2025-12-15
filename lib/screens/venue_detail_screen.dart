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

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  void _loadFields() async {
    final data = await ApiService.getFields(widget.venue.id);
    setState(() {
      fields = data;
      isLoading = false;
      if (fields.isNotEmpty) {
        selectedField = fields[0];
        _checkSlots();
      }
    });
  }

  void _checkSlots() async {
    if (selectedField == null) return;
    String dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

    final slots = await ApiService.checkAvailability(
      selectedField!.id,
      dateStr,
    );

    setState(() {
      bookedSlots = slots;
      userSelectedSlots.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.venue.imageUrl,
                fit: BoxFit.cover,
              ),
              title: Text(
                widget.venue.name,
                style: const TextStyle(fontSize: 16),
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
                    const CircularProgressIndicator()
                  else
                    ...fields.map((field) => _buildFieldItem(field)),

                  const SizedBox(height: 20),

                  const Text(
                    "Pilih Tanggal",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildDatePicker(),

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

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: userSelectedSlots.isEmpty
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Booking ${userSelectedSlots.length} jam...",
                      ),
                    ),
                  );
                },
          child: Text(
            "Booking (${userSelectedSlots.length} Jam)",
            style: const TextStyle(color: Colors.white),
          ),
        ),
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
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
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
              "Rp ${field.pricePerHour}/jam",
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected = date.day == selectedDate.day;
          return GestureDetector(
            onTap: () {
              setState(() => selectedDate = date);
              _checkSlots();
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey[300]!,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE').format(date)),
                  Text(
                    "${date.day}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
        bool isUserSelected = userSelectedSlots.contains(timeLabel);

        Color bgColor = Colors.white;
        Color textColor = Colors.black;

        if (status == 'booked') {
          bgColor = Colors.red.shade100;
          textColor = Colors.red;
        } else if (status == 'locked') {
          bgColor = Colors.amber.shade100;
          textColor = Colors.orange[800]!;
        } else if (isUserSelected) {
          bgColor = Colors.green;
          textColor = Colors.white;
        }

        return GestureDetector(
          onTap: () {
            if (status != 'available') return;
            setState(() {
              if (isUserSelected)
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
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

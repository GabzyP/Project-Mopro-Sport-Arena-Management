import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import 'add_field_screen.dart'; // Import formulir tambah lapangan

class VenueDetailAdminScreen extends StatefulWidget {
  final Venue venue;

  const VenueDetailAdminScreen({required this.venue, super.key});

  @override
  State<VenueDetailAdminScreen> createState() => _VenueDetailAdminScreenState();
}

class _VenueDetailAdminScreenState extends State<VenueDetailAdminScreen> {
  // Pastikan fields adalah List<Field> yang didefinisikan di models/venue_model.dart
  List<Field> fields = []; 
  bool isLoading = true;
  final Color primaryColor = const Color(0xFF22c55e); 

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  void _loadFields() async {
    // Memanggil API Service untuk mengambil Lapangan (sesuai backend)
    try {
      final data = await ApiService.getFields(widget.venue.id);
      if (mounted) {
        setState(() {
          fields = data;
          isLoading = false;
        });
      }
    } catch (e) {
       if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat lapangan: $e')),
        );
      }
    }
  }

  // Fungsi navigasi untuk menambah lapangan
  void _navigateToAddField() async {
    // Navigasi ke formulir AddFieldScreen, membawa data Venue sebagai target
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFieldScreen(targetVenue: widget.venue),
      ),
    );
    
    // Jika result adalah true (berhasil ditambahkan) atau ada perubahan, refresh daftar lapangan
    if (result == true) {
      _loadFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lapangan di ${widget.venue.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metrik Ringkasan
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Text('Total Lapangan: ${fields.length} unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : fields.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum ada lapangan terdaftar di venue ini.'),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _navigateToAddField,
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Lapangan Pertama'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: fields.length,
                        itemBuilder: (context, index) {
                          final field = fields[index];
                          return ListTile(
                            leading: const Icon(Icons.grass, color: Colors.green),
                            title: Text(field.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('Jenis: ${field.sportType.toUpperCase()} | Harga: Rp ${field.pricePerHour.toStringAsFixed(0)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, size: 20, color: Colors.orange),
                              onPressed: () {
                                // TODO: Navigasi ke EditFieldScreen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Fungsi Edit Lapangan ${field.name}')),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      
      // Tombol Aksi Admin: Tambah Lapangan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddField,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Lapangan'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
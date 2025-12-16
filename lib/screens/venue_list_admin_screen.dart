import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import 'venue_detail_admin_screen.dart'; // Navigasi ke halaman detail admin

class VenueListAdminScreen extends StatefulWidget {
  const VenueListAdminScreen({super.key});

  @override
  State<VenueListAdminScreen> createState() => _VenueListAdminScreenState();
}

class _VenueListAdminScreenState extends State<VenueListAdminScreen> {
  List<Venue> venues = [];
  bool isLoading = true;
  final Color primaryColor = const Color(0xFF22c55e); 

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() async {
    // Menggunakan API service yang sudah ada untuk mengambil daftar venue
    final data = await ApiService.getVenues();
    if (mounted) {
      setState(() {
        venues = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Venue', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Tambah Venue Baru (Fitur Admin Lain)
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () {
              // TODO: Navigasi ke AddVenueScreen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fungsi Tambah Venue Belum diimplementasikan')),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final venue = venues[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.sports_soccer, color: Colors.blueGrey),
                    title: Text(venue.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${venue.address} | Rating: ${venue.rating}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigasi ke halaman detail admin (tempat kita akan menambah lapangan)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VenueDetailAdminScreen(venue: venue),
                        ),
                      ).then((_) => _loadVenues()); // Refresh setelah kembali
                    },
                  ),
                );
              },
            ),
    );
  }
}
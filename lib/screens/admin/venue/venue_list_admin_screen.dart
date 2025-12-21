import 'package:flutter/material.dart';
import 'package:kelompok6_sportareamanagement/models/venue_model.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';
import 'package:kelompok6_sportareamanagement/screens/admin/venue/venue_detail_admin_screen.dart';
import 'package:kelompok6_sportareamanagement/screens/admin/venue/add_venue_screen.dart';

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
        title: const Text(
          'Manajemen Venue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddVenueScreen()),
              ).then((result) {
                if (result == true) {
                  _loadVenues();
                }
              });
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(
                      Icons.sports_soccer,
                      color: Colors.blueGrey,
                    ),
                    title: Text(
                      venue.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${venue.address} | Rating: ${venue.rating}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VenueDetailAdminScreen(venue: venue),
                        ),
                      ).then((_) => _loadVenues());
                    },
                  ),
                );
              },
            ),
    );
  }
}

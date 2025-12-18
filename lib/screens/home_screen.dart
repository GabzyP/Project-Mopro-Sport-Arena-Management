import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import '../widgets/venue_card.dart';
import 'venue_detail_screen.dart';
import 'location_picker_screen.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF22c55e);
  final Color secondaryColor = const Color.fromARGB(255, 87, 55, 0);
  final Color bgColor = const Color(0xFFf9fafb);

  String currentLocation = "Pilih Lokasi";

  List<Venue> venues = [];
  List<Venue> filteredVenues = [];
  bool isLoading = true;
  String selectedSport = 'all';
  String searchQuery = '';

  double? selectedLat;
  double? selectedLng;

  final List<Map<String, dynamic>> sportFilters = [
    {'id': 'all', 'label': 'Semua', 'emoji': '🏟'},
    {'id': 'futsal', 'label': 'Futsal', 'emoji': '⚽'},
    {'id': 'badminton', 'label': 'Badminton', 'emoji': '🏸'},
    {'id': 'tennis', 'label': 'Tenis', 'emoji': '🎾'},
    {'id': 'basketball', 'label': 'Basket', 'emoji': '🏀'},
    {'id': 'volleyball', 'label': 'Voli', 'emoji': '🏐'},
  ];

  Map<String, dynamic> homeStats = {
    "total_venues": "-",
    "total_fields": "-",
    "availability": "-",
  };

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() async {
    final dataVenues = await ApiService.getVenues();
    if (dataVenues.isNotEmpty) {
      print(
        "DEBUG: Venue ${dataVenues[0].name} - Lat: ${dataVenues[0].latitude}",
      );
    }
    final dataStats = await ApiService.getHomeStats();

    if (mounted) {
      setState(() {
        venues = dataVenues;
        filteredVenues = dataVenues;
        homeStats = dataStats;
        isLoading = false;
      });
    }
  }

  void _filterVenues() {
    setState(() {
      filteredVenues = venues.where((venue) {
        final matchSport =
            selectedSport == 'all' ||
            venue.sportTypes.any(
              (s) => s.toLowerCase().contains(selectedSport.toLowerCase()),
            );

        final matchSearch =
            venue.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            venue.address.toLowerCase().contains(searchQuery.toLowerCase());

        bool matchLocation = true;
        if (selectedLat != null && selectedLng != null) {
          double distanceInMeters = Geolocator.distanceBetween(
            selectedLat!,
            selectedLng!,
            venue.latitude,
            venue.longitude,
          );
          if (distanceInMeters > 500000) {
            matchLocation = false;
          }
        }

        return matchSport && matchSearch && matchLocation;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang 👋',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'Sport Arena',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) {
                        searchQuery = val;
                        _filterVenues();
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari venue atau lokasi...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: primaryColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      currentLocation,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationPickerScreen(),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          currentLocation =
                              result['address'] ?? "Lokasi tidak diketahui";
                          selectedLat = double.tryParse(
                            result['lat'].toString(),
                          );
                          selectedLng = double.tryParse(
                            result['lng'].toString(),
                          );
                          _filterVenues();
                        });
                      }
                    },
                    child: Text(
                      'Ubah',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: sportFilters.map((filter) {
                  bool isSelected = selectedSport == filter['id'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSport = filter['id'];
                        _filterVenues();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 2,
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          Text(filter['emoji']),
                          const SizedBox(width: 6),
                          Text(
                            filter['label'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    homeStats['total_venues'].toString(),
                    'Venue',
                    primaryColor,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    homeStats['total_fields'].toString(),
                    'Lapangan',
                    secondaryColor,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    homeStats['availability'].toString(),
                    'Tersedia',
                    primaryColor,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Venue Terdekat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (filteredVenues.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredVenues.length,
                      itemBuilder: (context, index) {
                        return VenueCard(
                          venue: filteredVenues[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VenueDetailScreen(
                                venue: filteredVenues[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String val, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
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
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: const [
          Text('🏟', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Tidak ada venue',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Coba ubah filter atau lokasi pencarian',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';
import '../widgets/venue_card.dart';
import 'venue_detail_screen.dart';
import 'location_picker_screen.dart';
import 'notification_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  void _loadVenues() async {
    final dataVenues = await ApiService.getVenues();

    if (mounted) {
      setState(() {
        venues = dataVenues;
        filteredVenues = dataVenues;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1577223625816-7546f13df25d?q=80&w=2070&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black26,
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.only(
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
                            'Selamat Datang di',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Shibuya Arena',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
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
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
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
                        color: isSelected
                            ? primaryColor
                            : Theme.of(context).cardColor,
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
                                  color: Colors.black.withOpacity(0.05),
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
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
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

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
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

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: const [
          Text('🏟', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
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

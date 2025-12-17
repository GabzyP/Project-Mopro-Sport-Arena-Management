import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LevelMemberScreen extends StatefulWidget {
  const LevelMemberScreen({super.key});

  @override
  State<LevelMemberScreen> createState() => _LevelMemberScreenState();
}

class _LevelMemberScreenState extends State<LevelMemberScreen> {
  int currentPoints = 0;
  bool isLoading = true;

  final List<Map<String, dynamic>> levels = [
    {"name": "Bronze", "min": 0, "max": 500, "color": Colors.brown},
    {"name": "Silver", "min": 500, "max": 1500, "color": Colors.grey},
    {"name": "Gold", "min": 1500, "max": 3000, "color": Colors.amber},
    {"name": "Platinum", "min": 3000, "max": 999999, "color": Colors.blueGrey},
  ];

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  void _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('userId');
    if (uid != null) {
      final data = await ApiService.getUserDetails(uid);
      if (mounted && data['status'] == 'success') {
        setState(() {
          currentPoints = int.parse(data['data']['points'] ?? '0');
          isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _getCurrentLevel() {
    return levels.lastWhere(
      (l) => currentPoints >= l['min'],
      orElse: () => levels[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    var level = _getCurrentLevel();
    var nextLevel = levels.firstWhere(
      (l) => l['min'] > currentPoints,
      orElse: () => {},
    );
    double progress = 0.0;

    if (nextLevel.isNotEmpty) {
      progress =
          (currentPoints - level['min']) / (nextLevel['min'] - level['min']);
    } else {
      progress = 1.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Level Member"),
        backgroundColor: const Color(0xFF22c55e),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF22c55e), Color(0xFF16a34a)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.star, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Level Saat Ini",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  "${level['name']} Member",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$currentPoints Poin",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (nextLevel.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Menuju ${nextLevel['name']}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "${nextLevel['min'] - currentPoints} poin lagi",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ] else
                          const Text(
                            "Anda mencapai level tertinggi!",
                            style: TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Benefit Level",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem(
                    "Bronze",
                    "Akses booking standar",
                    currentPoints >= 0,
                  ),
                  _buildBenefitItem(
                    "Silver",
                    "Diskon 5%, Prioritas Booking",
                    currentPoints >= 500,
                  ),
                  _buildBenefitItem(
                    "Gold",
                    "Diskon 10%, Free Drink 1x/bln",
                    currentPoints >= 1500,
                  ),
                  _buildBenefitItem(
                    "Platinum",
                    "Diskon 15%, Personal Assistant",
                    currentPoints >= 3000,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBenefitItem(String level, String benefit, bool isUnlocked) {
    return Card(
      color: isUnlocked ? Colors.white : Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          isUnlocked ? Icons.check_circle : Icons.lock,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
        title: Text(
          level,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(benefit),
      ),
    );
  }
}

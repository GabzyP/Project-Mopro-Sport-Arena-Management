import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LevelMemberScreen extends StatefulWidget {
  const LevelMemberScreen({super.key});

  @override
  State<LevelMemberScreen> createState() => _LevelMemberScreenState();
}

class _LevelMemberScreenState extends State<LevelMemberScreen> {
  int currentPoints = 320;

  final List<Map<String, dynamic>> memberTiers = [
    {
      'name': 'Bronze',
      'icon': '🥉',
      'minPoints': 0,
      'benefits': ['Akses booking standar', 'Notifikasi promo'],
      'current': false,
    },
    {
      'name': 'Silver',
      'icon': '🥈',
      'minPoints': 100,
      'benefits': ['Diskon 5%', 'Prioritas booking', 'Akses early bird promo'],
      'current': false,
    },
    {
      'name': 'Gold',
      'icon': '🥇',
      'minPoints': 300,
      'benefits': [
        'Diskon 10%',
        'Free reschedule 2x/bulan',
        'Customer support prioritas',
      ],
      'current': true,
    },
    {
      'name': 'Platinum',
      'icon': '💎',
      'minPoints': 600,
      'benefits': [
        'Diskon 15%',
        'Free cancel 1x/bulan',
        'Exclusive venue access',
        'Personal assistant',
      ],
      'current': false,
    },
  ];

  final List<Map<String, dynamic>> availableRewards = [
    {
      'id': 1,
      'title': 'Voucher Rp 50.000',
      'points': 50,
      'icon': Icons.confirmation_number,
      'color': Colors.amber,
    },
    {
      'id': 2,
      'title': 'Free Booking 1 Jam',
      'points': 100,
      'icon': Icons.access_time_filled,
      'color': Colors.redAccent,
    },
    {
      'id': 3,
      'title': 'Merchandise Eksklusif',
      'points': 150,
      'icon': Icons.checkroom,
      'color': Colors.green,
    },
    {
      'id': 4,
      'title': 'Upgrade ke Gold',
      'points': 200,
      'icon': Icons.emoji_events,
      'color': Colors.orange,
    },
    {
      'id': 5,
      'title': 'VIP Access 1 Bulan',
      'points': 300,
      'icon': Icons.diamond,
      'color': Colors.blue,
    },
    {
      'id': 6,
      'title': 'Free Booking 3 Jam',
      'points': 250,
      'icon': Icons.track_changes,
      'color': Colors.pink,
    },
  ];

  final List<Map<String, dynamic>> rewardHistory = [
    {
      'id': 1,
      'title': 'Booking Futsal',
      'points': '+10',
      'date': '15 Jan 2025',
      'type': 'earn',
    },
    {
      'id': 2,
      'title': 'Tukar Voucher 50k',
      'points': '-50',
      'date': '10 Jan 2025',
      'type': 'redeem',
    },
    {
      'id': 3,
      'title': 'Booking Badminton',
      'points': '+10',
      'date': '8 Jan 2025',
      'type': 'earn',
    },
    {
      'id': 4,
      'title': 'Bonus Member Gold',
      'points': '+50',
      'date': '1 Jan 2025',
      'type': 'bonus',
    },
  ];

  void _redeemPoint(int cost, String title) {
    if (currentPoints >= cost) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text("Tukar $cost poin untuk $title?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22c55e),
              ),
              onPressed: () {
                setState(() {
                  currentPoints -= cost;
                  rewardHistory.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'title': "Tukar $title",
                    'points': "-$cost",
                    'date': "Hari ini",
                    'type': 'redeem',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Berhasil ditukar!")),
                );
              },
              child: const Text("Tukar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Poin tidak cukup!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTier = memberTiers.firstWhere((t) => t['current'] == true);
    final currentIndex = memberTiers.indexOf(currentTier);
    final nextTier = (currentIndex + 1 < memberTiers.length)
        ? memberTiers[currentIndex + 1]
        : null;

    double progressValue = 1.0;
    int pointsNeeded = 0;

    if (nextTier != null) {
      int minCurrent = currentTier['minPoints'] as int;
      int minNext = nextTier['minPoints'] as int;
      if (minNext > minCurrent) {
        progressValue = (currentPoints - minCurrent) / (minNext - minCurrent);
        progressValue = progressValue.clamp(0.0, 1.0);
      }
      pointsNeeded = minNext - currentPoints;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(
              currentTier,
              nextTier,
              progressValue,
              pointsNeeded,
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitsCard(currentTier),
                  const SizedBox(height: 24),

                  const Text(
                    "Semua Level",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...memberTiers.map((tier) => _buildTierItem(tier)),
                  const SizedBox(height: 24),

                  const Text(
                    "Tukar Poin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: availableRewards.length,
                    itemBuilder: (context, index) {
                      return _buildRewardGridItem(availableRewards[index]);
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Riwayat Poin",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: rewardHistory
                          .map((item) => _buildHistoryItem(item))
                          .toList(),
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

  Widget _buildRewardGridItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _redeemPoint(item['points'], item['title']),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF22c55e).withOpacity(0.3),
          ), // Border hijau tipis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(item['icon'], size: 32, color: item['color']),

            Text(
              item['title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22c55e),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${item['points']} poin",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.check, color: Color(0xFF22c55e), size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    Map<String, dynamic> currentTier,
    Map<String, dynamic>? nextTier,
    double progress,
    int pointsNeeded,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF22c55e), Color(0xFF15803d)],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Member Rank",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      currentTier['icon'],
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Level Saat Ini",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          currentTier['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "$currentPoints Poin",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (nextTier != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentTier['name'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        nextTier['name'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$pointsNeeded poin lagi untuk ${nextTier['name']}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard(Map<String, dynamic> tier) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  size: 20,
                  color: Color(0xFF22c55e),
                ),
                const SizedBox(width: 8),
                Text(
                  "Benefit ${tier['name']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(tier['benefits'] as List<String>).map((benefit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTierItem(Map<String, dynamic> tier) {
    bool isCurrent = tier['current'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent
            ? Border.all(color: const Color(0xFF22c55e), width: 1.5)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Text(tier['icon'], style: const TextStyle(fontSize: 28)),
        title: Row(
          children: [
            Text(
              tier['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF22c55e).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Saat Ini",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF22c55e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          "${tier['minPoints']} poin minimum",
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    bool isRedeem = item['type'] == 'redeem';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['date'],
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          Text(
            item['points'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isRedeem ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LevelMemberScreen extends StatefulWidget {
  final int currentPoints;
  const LevelMemberScreen({super.key, required this.currentPoints});

  @override
  State<LevelMemberScreen> createState() => _LevelMemberScreenState();
}

class _LevelMemberScreenState extends State<LevelMemberScreen> {
  late int currentPoints;
  List<Map<String, dynamic>> rewardHistory = [];
  bool isLoading = false;

  final List<Map<String, dynamic>> memberTiers = [
    {
      'name': 'Bronze',
      'icon': '🥉',
      'minPoints': 100,
      'benefits': ['Akses booking standar', 'Notifikasi promo'],
    },
    {
      'name': 'Silver',
      'icon': '🥈',
      'minPoints': 500,
      'benefits': ['Diskon 5%', 'Prioritas booking', 'Akses early bird promo'],
    },
    {
      'name': 'Gold',
      'icon': '🥇',
      'minPoints': 2000,
      'benefits': [
        'Diskon 10%',
        'Free reschedule 2x/bulan',
        'Customer support prioritas',
      ],
    },
    {
      'name': 'Platinum',
      'icon': '💠',
      'minPoints': 10000,
      'benefits': [
        'Diskon 15%',
        'Free cancel 1x/bulan',
        'Exclusive venue access',
      ],
    },
    {
      'name': 'Diamond',
      'icon': '💎',
      'minPoints': 100000,
      'benefits': [
        'Diskon 20%',
        'Personal assistant',
        'Undangan event eksklusif',
      ],
    },
    {
      'name': 'Master',
      'icon': '👑',
      'minPoints': 1000000,
      'benefits': [
        'All Access Pass',
        'Bebas biaya admin selamanya',
        'Hadiah ulang tahun spesial',
      ],
    },
  ];

  final List<Map<String, dynamic>> availableRewards = [
    {
      'id': 1,
      'title': 'Voucher Rp 50.000',
      'points': 500,
      'icon': Icons.confirmation_number,
      'color': Colors.amber,
    },
    {
      'id': 2,
      'title': 'Free Booking 1 Jam',
      'points': 1000,
      'icon': Icons.access_time_filled,
      'color': Colors.redAccent,
    },
    {
      'id': 3,
      'title': 'Merchandise Eksklusif',
      'points': 1500,
      'icon': Icons.checkroom,
      'color': Colors.green,
    },
    {
      'id': 4,
      'title': 'VIP Access 1 Bulan',
      'points': 5000,
      'icon': Icons.diamond,
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    currentPoints = widget.currentPoints;
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final details = await ApiService.getUserDetails(userId);
      final history = await ApiService.getRewardHistory(userId);

      if (mounted) {
        setState(() {
          currentPoints =
              int.tryParse(details['points'].toString()) ?? currentPoints;
          rewardHistory = history.map((e) {
            return {
              'title': e['reward_title'] ?? 'Hadiah',
              'points': "-${e['points_cost']}",
              'date': e['redeemed_at'] ?? '',
              'type': 'redeem',
            };
          }).toList();
        });
      }
    }
  }

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
              onPressed: () async {
                Navigator.pop(ctx);
                setState(() => isLoading = true);

                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId');

                if (userId != null) {
                  final result = await ApiService.redeemReward(
                    userId: userId,
                    rewardTitle: title,
                    pointsCost: cost,
                  );

                  if (mounted) {
                    setState(() => isLoading = false);
                    if (result['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Berhasil ditukar!")),
                      );
                      _loadData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'] ?? "Gagal")),
                      );
                    }
                  }
                }
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

  Map<String, dynamic> _getCurrentTier() {
    Map<String, dynamic> current = memberTiers.first;
    for (var tier in memberTiers) {
      if (currentPoints >= tier['minPoints']) {
        current = tier;
      } else {
        break;
      }
    }
    return current;
  }

  Map<String, dynamic>? _getNextTier() {
    Map<String, dynamic> current = _getCurrentTier();
    int index = memberTiers.indexOf(current);
    if (index + 1 < memberTiers.length) {
      return memberTiers[index + 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentTier = _getCurrentTier();
    final nextTier = _getNextTier();

    double progressValue = 1.0;
    int pointsNeeded = 0;

    if (nextTier != null) {
      int minCurrent = currentTier['minPoints'] as int;
      int minNext = nextTier['minPoints'] as int;

      if (minNext > minCurrent) {}

      int base = currentTier['minPoints'];
      int target = nextTier['minPoints'];

      if (currentPoints < 100 && currentTier['name'] == 'Newbie') {
        base = 0;
        target = 100;
      }

      if (target > base) {
        progressValue = (currentPoints - base) / (target - base);
      }

      progressValue = progressValue.clamp(0.0, 1.0);
      pointsNeeded = target - currentPoints;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  ...memberTiers.map((tier) {
                    bool isCurrent = tier['name'] == currentTier['name'];
                    return _buildTierItem(tier, isCurrent);
                  }),
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
                    color: Theme.of(context).cardColor,
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF22c55e).withOpacity(0.3)),
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
      color: Theme.of(context).cardColor,
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
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
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

  Widget _buildTierItem(Map<String, dynamic> tier, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.blueGrey[400]),
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
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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

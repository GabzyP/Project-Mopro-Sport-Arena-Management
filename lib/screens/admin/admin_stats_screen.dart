import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  final Color primaryColor = const Color(0xFF22c55e);

  Map<String, dynamic> stats = {
    "today_bookings": "0",
    "total_revenue": "0",
    "active_users": "0",
    "pending_orders": "0",
  };

  List<double> monthlyRevenueList = List.filled(6, 0.0);
  List<DateTime> monthLabels = [];

  Map<String, int> sportCounts = {};
  Map<int, int> primeTimeCounts = {};
  Map<String, int> fieldPopularity = {};

  Map<String, Map<String, dynamic>> paymentStats = {};

  int totalSportsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await ApiService.getAdminDashboardData();
    if (mounted) {
      setState(() {
        stats = data['stats'] ?? stats;
        List<dynamic> orders = data['orders'] ?? [];

        monthlyRevenueList = List.filled(6, 0.0);
        monthLabels.clear();
        DateTime now = DateTime.now();
        for (int i = 5; i >= 0; i--) {
          DateTime m = DateTime(now.year, now.month - i, 1);
          monthLabels.add(m);
        }

        sportCounts = {"Futsal": 0, "Badminton": 0, "Basket": 0};
        primeTimeCounts = {};
        fieldPopularity = {};
        paymentStats = {};
        totalSportsCount = 0;

        for (var order in orders) {
          double price =
              double.tryParse(order['total_price'].toString()) ?? 0.0;
          DateTime date = DateTime.parse(order['booking_date']);

          for (int i = 0; i < 6; i++) {
            if (monthLabels[i].month == date.month &&
                monthLabels[i].year == date.year) {
              monthlyRevenueList[i] += price;
              break;
            }
          }

          String sport = _normalizeSport(order['sport_type']);
          sportCounts[sport] = (sportCounts[sport] ?? 0) + 1;

          String timeStr = order['start_time'] ?? "00:00:00";
          int hour = int.parse(timeStr.split(':')[0]);
          primeTimeCounts[hour] = (primeTimeCounts[hour] ?? 0) + 1;

          String fieldName = order['field_name'] ?? "Unknown";
          fieldPopularity[fieldName] = (fieldPopularity[fieldName] ?? 0) + 1;

          String method = order['payment_method'] ?? 'Lainnya';
          if (method.isEmpty) method = 'Tunai';

          if (!paymentStats.containsKey(method)) {
            paymentStats[method] = {'count': 0, 'total': 0.0};
          }
          paymentStats[method]!['count'] += 1;
          paymentStats[method]!['total'] += price;

          totalSportsCount++;
        }
        isLoading = false;
      });
    }
  }

  String _normalizeSport(String? raw) {
    String s = (raw ?? "").toLowerCase();
    if (s.contains('futsal')) return "Futsal";
    if (s.contains('badminton')) return "Badminton";
    if (s.contains('basket')) return "Basket";
    if (s.contains('tennis')) return "Tennis";
    return "Lainnya";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              color: const Color(0xFF3E2723),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Statistik",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Analisis Performa Venue Real Time",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatCard(
                        "Hari Ini",
                        stats['today_bookings'].toString(),
                        Icons.calendar_today,
                        Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        "Pending",
                        stats['pending_orders'].toString(),
                        Icons.timer,
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(
                        "Users",
                        stats['active_users'].toString(),
                        Icons.people,
                        Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        "Pendapatan",
                        _formatMoneyCompact(stats['total_revenue']),
                        Icons.attach_money,
                        Colors.amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSectionContainer(
                    title: "Pendapatan Bulanan",
                    icon: Icons.bar_chart,
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY:
                              (monthlyRevenueList.fold(
                                0.0,
                                (p, c) => p > c ? p : c,
                              )) *
                              1.2,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (val, _) {
                                  int idx = val.toInt();
                                  if (idx >= 0 && idx < monthLabels.length) {
                                    return Text(
                                      _getMonthName(monthLabels[idx].month),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(6, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: monthlyRevenueList[index],
                                  color: primaryColor,
                                  width: 22,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionContainer(
                    title: "Jam Prime Time",
                    icon: Icons.access_time,
                    child: Column(children: _buildPrimeTimeList()),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionContainer(
                    title: "Popularitas Olahraga",
                    icon: Icons.emoji_events_outlined,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: _getPieSections(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegend(
                                "Futsal",
                                Colors.green,
                                sportCounts['Futsal'] ?? 0,
                              ),
                              _buildLegend(
                                "Badminton",
                                Colors.blue,
                                sportCounts['Badminton'] ?? 0,
                              ),
                              _buildLegend(
                                "Basket",
                                Colors.orange,
                                sportCounts['Basket'] ?? 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionContainer(
                    title: "Lapangan Terlaris",
                    icon: Icons.emoji_events,
                    iconColor: Colors.amber,
                    child: Column(children: _buildTopFieldsList()),
                  ),

                  const SizedBox(height: 20),

                  _buildSectionContainer(
                    title: "Metode Pembayaran",
                    icon: Icons.payment,
                    child: Column(children: _buildPaymentList()),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPaymentList() {
    if (paymentStats.isEmpty)
      return [
        const Text(
          "Belum ada data pembayaran",
          style: TextStyle(color: Colors.grey),
        ),
      ];

    var sortedPayment = paymentStats.entries.toList()
      ..sort(
        (a, b) =>
            (b.value['total'] as double).compareTo(a.value['total'] as double),
      );

    return sortedPayment.map((entry) {
      String name = entry.key;
      int count = entry.value['count'];
      double total = entry.value['total'];

      Color color;
      String lowerName = name.toLowerCase();
      if (lowerName.contains('gopay'))
        color = Colors.green;
      else if (lowerName.contains('ovo'))
        color = Colors.purple;
      else if (lowerName.contains('dana'))
        color = Colors.blue;
      else if (lowerName.contains('shopee'))
        color = Colors.orange;
      else if (lowerName.contains('bca'))
        color = Colors.blue[900]!;
      else if (lowerName.contains('mandiri'))
        color = Colors.yellow[800]!;
      else if (lowerName.contains('bri'))
        color = Colors.blue[700]!;
      else if (lowerName.contains('bni'))
        color = Colors.teal;
      else if (lowerName.contains('linkaja'))
        color = Colors.red;
      else if (lowerName.contains('transfer'))
        color = Colors.indigo;
      else
        color = Colors.grey;

      return _buildPaymentRow(
        name,
        "${count}x",
        _formatMoneyCompact(total),
        color,
      );
    }).toList();
  }

  Widget _buildSectionContainer({
    required String title,
    required IconData icon,
    required Widget child,
    Color iconColor = Colors.grey,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor == Colors.grey ? primaryColor : iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  List<Widget> _buildPrimeTimeList() {
    var sortedHours = primeTimeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var topHours = sortedHours.take(5).toList();
    if (topHours.isEmpty)
      return [
        const Text(
          "Belum ada data booking",
          style: TextStyle(color: Colors.grey),
        ),
      ];
    int maxVal = topHours.first.value;

    return topHours.map((e) {
      String hourLabel = "${e.key.toString().padLeft(2, '0')}:00";
      double percent = e.value / maxVal;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            SizedBox(
              width: 45,
              child: Text(
                hourLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percent,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor.withOpacity(0.6), primaryColor],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 30,
              child: Text(
                "${e.value}",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildTopFieldsList() {
    var sortedFields = fieldPopularity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var topFields = sortedFields.take(5).toList();
    if (topFields.isEmpty)
      return [
        const Text("Belum ada data", style: TextStyle(color: Colors.grey)),
      ];

    return topFields.asMap().entries.map((entry) {
      int idx = entry.key + 1;
      var data = entry.value;
      Color badgeColor = idx == 1
          ? Colors.amber
          : (idx == 2 ? Colors.grey : Colors.brown[300]!);
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: idx <= 3
                    ? badgeColor.withOpacity(0.2)
                    : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Text(
                "$idx",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: idx <= 3 ? badgeColor : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.key,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${data.value} booking",
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildPaymentRow(
    String name,
    String count,
    String total,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            total,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, Color color, int count) {
    int pct = totalSportsCount > 0
        ? ((count / totalSportsCount) * 100).round()
        : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          Text("$pct%", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieSections() {
    if (totalSportsCount == 0)
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey[200],
          radius: 15,
          showTitle: false,
        ),
      ];
    return [
      PieChartSectionData(
        value: (sportCounts['Futsal'] ?? 0).toDouble(),
        color: Colors.green,
        radius: 15,
        showTitle: false,
      ),
      PieChartSectionData(
        value: (sportCounts['Badminton'] ?? 0).toDouble(),
        color: Colors.blue,
        radius: 15,
        showTitle: false,
      ),
      PieChartSectionData(
        value: (sportCounts['Basket'] ?? 0).toDouble(),
        color: Colors.orange,
        radius: 15,
        showTitle: false,
      ),
    ];
  }

  String _formatMoneyCompact(dynamic val) {
    double v = double.tryParse(val.toString()) ?? 0;
    if (v >= 1000000) return "${(v / 1000000).toStringAsFixed(1)}jt";
    if (v >= 1000) return "${(v / 1000).toStringAsFixed(1)}rb";
    return v.toInt().toString();
  }

  String _getMonthName(int index) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    if (index >= 1 && index <= 12) return months[index];
    return '';
  }
}

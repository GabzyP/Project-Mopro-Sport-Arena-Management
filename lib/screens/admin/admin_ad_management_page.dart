import 'package:flutter/material.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';

class AdminAdManagementPage extends StatefulWidget {
  const AdminAdManagementPage({super.key});

  @override
  State<AdminAdManagementPage> createState() => _AdminAdManagementPageState();
}

class _AdminAdManagementPageState extends State<AdminAdManagementPage> {
  final Color headerColor = const Color(0xFF3E2723);
  List<dynamic> ads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAds();
  }

  void _fetchAds() async {
    final result = await ApiService.getAds();
    if (mounted) {
      setState(() {
        ads = result;
        isLoading = false;
      });
    }
  }

  void _showAddAdDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final valueController = TextEditingController(text: "0");
    String selectedPromo = 'none';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Buat Iklan Baru"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Nama Iklan"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPromo,
                    decoration: const InputDecoration(labelText: "Promo Iklan"),
                    items: const [
                      DropdownMenuItem(value: 'none', child: Text("Tidak Ada")),
                      DropdownMenuItem(
                        value: 'discount',
                        child: Text("Diskon (%)"),
                      ),
                      DropdownMenuItem(
                        value: 'cashback',
                        child: Text("Cashback (Poin)"),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedPromo = val!),
                  ),
                  if (selectedPromo != 'none')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: valueController,
                        decoration: InputDecoration(
                          labelText: selectedPromo == 'discount'
                              ? "Besar Diskon (%)"
                              : "Jumlah Cashback",
                          suffixText: selectedPromo == 'discount' ? "%" : "pts",
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) return;

                  final success = await ApiService.addAd(
                    title: titleController.text,
                    description: descController.text,
                    promoType: selectedPromo,
                    promoValue: double.tryParse(valueController.text) ?? 0,
                  );

                  if (success) {
                    Navigator.pop(context);
                    _fetchAds();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Iklan berhasil ditambahkan"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menambah iklan")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22c55e),
                ),
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteAd(String id) async {
    final success = await ApiService.deleteAd(id);
    if (success) {
      _fetchAds();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Iklan dihapus")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAdDialog,
        backgroundColor: const Color(0xFF22c55e),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(color: headerColor),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kelola Iklan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Manajemen banner promo",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ads.isEmpty
                ? const Center(child: Text("Belum ada iklan aktif"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return _buildAdCard(ad);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(dynamic ad) {
    String type = ad['promo_type'] ?? 'none';

    Color themeColor;
    IconData icon;
    String promoText = "";

    if (type == 'discount') {
      themeColor = Colors.red;
      icon = Icons.local_offer;
      promoText = "Diskon ${ad['promo_value']}%";
    } else if (type == 'cashback') {
      themeColor = Colors.orange;
      icon = Icons.monetization_on;
      promoText = "Cashback ${ad['promo_value']} pts";
    } else {
      themeColor = Colors.blue;
      icon = Icons.info_outline;
      promoText = "Info";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: themeColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ad['title'] ?? 'No Title',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              promoText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                      onPressed: () => _deleteAd(ad['id'].toString()),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ad['description'] ?? '',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

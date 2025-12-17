import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Bantuan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Cari bantuan...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // FAQ
            const Text(
              "Pertanyaan Umum",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildFaqGroup("Booking", "📅", [
              {
                "q": "Cara booking lapangan?",
                "a": "Pilih venue, pilih jam, dan bayar.",
              },
              {"q": "Bisa batalkan booking?", "a": "Bisa, maksimal H-1."},
            ]),
            _buildFaqGroup("Pembayaran", "💳", [
              {"q": "Metode pembayaran?", "a": "Transfer Bank, E-Wallet."},
            ]),

            const SizedBox(height: 24),
            // CONTACT
            const Text(
              "Hubungi Kami",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildContactCard(Icons.message, "Live Chat", "Chat tim support"),
            _buildContactCard(Icons.email, "Email", "support@arenasport.id"),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqGroup(
    String title,
    String emoji,
    List<Map<String, String>> faqs,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "$emoji $title",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...faqs
                .map(
                  (f) => ExpansionTile(
                    title: Text(f['q']!, style: const TextStyle(fontSize: 14)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          f['a']!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF22c55e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF22c55e)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF22c55e)),
      ),
    );
  }
}

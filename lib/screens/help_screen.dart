import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk fitur Copy Paste

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Color primaryColor = const Color(0xFF22c55e);

  final List<Map<String, String>> faqs = [
    {
      "question": "Bagaimana cara membatalkan booking?",
      "answer":
          "Masuk ke menu 'Riwayat Booking', pilih booking yang ingin dibatalkan, lalu klik tombol 'Batalkan'. Pembatalan maksimal H-1 jadwal main.",
    },
    {
      "question": "Apakah bisa reschedule jadwal?",
      "answer":
          "Ya, Anda dapat melakukan reschedule 1 kali untuk setiap booking, maksimal 24 jam sebelum jadwal main.",
    },
    {
      "question": "Bagaimana sistem refund bekerja?",
      "answer":
          "Refund akan diproses dalam 3-5 hari kerja setelah pembatalan disetujui. Dana akan dikembalikan ke metode pembayaran yang sama.",
    },
    {
      "question": "Apa keuntungan menjadi Member Gold?",
      "answer":
          "Member Gold mendapatkan diskon 10% setiap booking, prioritas customer support, dan bebas biaya layanan.",
    },
    {
      "question": "Bagaimana cara upgrade member rank?",
      "answer":
          "Kumpulkan poin dengan sering melakukan booking. Setiap 100 poin akan menaikkan level member Anda.",
    },
  ];

  void _handleContactClick(String type) {
    switch (type) {
      case 'Live Chat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiveChatScreen()),
        );
        break;
      case 'Telepon':
        _showPhoneDialog();
        break;
      case 'Email':
        _showEmailDialog();
        break;
    }
  }

  void _showPhoneDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hubungi via Telepon",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.phone_in_talk,
                      size: 40,
                      color: Color(0xFF22c55e),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "021-1234-5678",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Senin - Minggu, 08:00 - 22:00 WIB",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: "02112345678"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nomor disalin!")),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Salin Nomor"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Telepon",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hubungi via Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 40,
                      color: Color(0xFF22c55e),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "help@sportvenue.id",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Respon dalam 1x24 jam",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: "help@sportvenue.id"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email disalin!")),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Salin Email"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Kirim Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Bantuan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari bantuan...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Hubungi Kami",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildContactCard(
                  Icons.chat_bubble_outline,
                  "Live Chat",
                  "Respon cepat 24/7",
                  Colors.green,
                  () => _handleContactClick('Live Chat'),
                ),
                const SizedBox(width: 12),
                _buildContactCard(
                  Icons.phone_outlined,
                  "Telepon",
                  "021-1234-5678",
                  Colors.blue,
                  () => _handleContactClick('Telepon'),
                ),
                const SizedBox(width: 12),
                _buildContactCard(
                  Icons.email_outlined,
                  "Email",
                  "help@sportvenue.id",
                  Colors.orange,
                  () => _handleContactClick('Email'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Pertanyaan Umum",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: faqs.map((faq) => _buildFaqItem(faq)).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _buildFooterLink(
              "Syarat & Ketentuan",
              Icons.description_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const TermsScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _buildFooterLink(
              "Kebijakan Privasi",
              Icons.privacy_tip_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const PrivacyPolicyScreen()),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 110,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, String> faq) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(
          faq['question']!,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq['answer']!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.grey[700]),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Halo! Selamat datang di SportVenue. Ada yang bisa kami bantu?",
      "isUser": false,
      "time": "00.54",
    },
  ];

  void _sendMessage() {
    if (_msgController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": _msgController.text,
          "isUser": true,
          "time": "${DateTime.now().hour}.${DateTime.now().minute}",
        });
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF22c55e),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Live Chat Support",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['isUser']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: msg['isUser']
                          ? const Color(0xFF22c55e)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg['isUser'] ? 16 : 0),
                        bottomRight: Radius.circular(msg['isUser'] ? 0 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: TextStyle(
                            color: msg['isUser']
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            fontSize: 10,
                            color: msg['isUser'] ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF22c55e)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFF22c55e)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF22c55e),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF22c55e),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("S & K", style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
  );
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Kebijakan Privasi",
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
  );
}

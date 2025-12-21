import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      "question": "Gimana cara booking lapangan?",
      "answer":
          "Gampang banget! Pilih venue yang kamu suka di home, cek jadwal yang kosong, pilih jam mainmu, terus bayar deh. Jangan lupa dateng tepat waktu ya!",
    },
    {
      "question": "Apa itu SportPoint & Member Rank?",
      "answer":
          "Setiap kamu booking, kamu dapet poin (1 poin tiap Rp 1.000). Makin banyak poin, rank kamu makin tinggi (Bronze sampe Master) dan benefitnya makin gokil!",
    },
    {
      "question": "Bisa batalin booking gak?",
      "answer":
          "Bisa dong, tapi maksimal H-1 ya. Masuk ke 'Riwayat Booking', pilih yang mau dibatalin. Kalau mepet jam main, sorry banget gak bisa refund ya sob.",
    },
    {
      "question": "Duit refund masuk ke mana?",
      "answer":
          "Tenang, duitmu aman. Refund bakal balik ke saldo 'My Wallet' di aplikasi ini atau ke rekening asal kamu dalam 1-3 hari kerja.",
    },
    {
      "question": "Gimana cara kasih review?",
      "answer":
          "Kelarin dulu mainnya, nanti di menu 'Riwayat Booking' atau 'Ulasan Saya' bakal muncul tombol buat kasih bintang & curhat soal venue-nya.",
    },
    {
      "question": "Apa guna fitur Favorit?",
      "answer":
          "Biar gak repot nyari venue langgananmu! Klik ikon hati di detail venue, nanti bakal muncul di menu 'Favorit Saya' di profil.",
    },
  ];

  List<Map<String, String>> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = faqs;
    _searchController.addListener(_filterFaqs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFaqs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFaqs = faqs.where((faq) {
        String question = faq['question']!.toLowerCase();
        String answer = faq['answer']!.toLowerCase();
        return question.contains(query) || answer.contains(query);
      }).toList();
    });
  }

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Pusat Bantuan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
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
                hintText: "Mau kepoin apa hari ini?",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Theme.of(context).cardColor,
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
              "Curhat Dong!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildContactCard(
                  Icons.chat_bubble_outline,
                  "Live Chat",
                  "Fast Response",
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
              "Yang Sering Ditanyain (FAQ)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: _filteredFaqs
                    .map((faq) => _buildFaqItem(faq))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            _buildFooterLink(
              "Aturan Main (S & K)",
              Icons.description_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const TermsScreen()),
              ),
            ),
            const SizedBox(height: 12),
            _buildFooterLink(
              "Rahasia Kita (Kebijakan Privasi)",
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
        color: Theme.of(context).cardColor,
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
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
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
      color: Theme.of(context).cardColor,
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
      "text":
          "Yo what's up! Admin SportVenue di sini. Ada yang bisa dibantu bro?",
      "isUser": false,
      "time": "NOW",
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

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            messages.add({
              "text": "Sabar ya sob, lagi dicek bentar...",
              "isUser": false,
              "time": "${DateTime.now().hour}.${DateTime.now().minute}",
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat Sama Admin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
                      hintText: "Tulis di sini...",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Aturan Main", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            "Wajib Baca Biar Gak Salah Paham!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _TermItem(
            "1. Sportif Itu Indah",
            "Dateng sesuai jadwal ya bro. Jangan telat, kasian yang main abis kamu.",
          ),
          _TermItem(
            "2. No Drama Refund",
            "Kalau mau batal, maksimal H-1. Lewat dari itu, anggep aja sedekah.",
          ),
          _TermItem(
            "3. Jaga Fasilitas",
            "Rusuh boleh pas main, tapi jangan ngerusak fasilitas venue. Nanti disuruh ganti rugi loh.",
          ),
          _TermItem(
            "4. Pembayaran",
            "Bayar pake apa aja boleh yang ada di aplikasi. Jangan ngutang ya hehe.",
          ),
          _TermItem(
            "5. Poin & Rank",
            "Poin yang udah didapet gak bisa dituker uang tunai. Cuma buat pamer rank & dapet diskon.",
          ),
          SizedBox(height: 20),
          Text(
            "Intinya kita di sini buat have fun & olahraga bareng. Setuju ya? Mantap!",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final String title;
  final String content;
  const _TermItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(color: Colors.grey[700], height: 1.5)),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Rahasia Kita",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            "Data Lo Aman, Bro!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _PrivacyItem(
            "1. Data yang Kita Simpen",
            "Nama, email, nomor HP, sama foto ganteng/cantik kamu. Cuma itu buat identitas booking.",
          ),
          _PrivacyItem(
            "2. Buat Apa?",
            "Biar kita tau siapa yang booking, dan buat ngasih info promo kalau ada.",
          ),
          _PrivacyItem(
            "3. Dijual Gak?",
            "Gila aja! Data lo rahasia negara buat kita. Gak bakal kita jual ke pinjol atau spammer.",
          ),
          _PrivacyItem(
            "4. Lokasi",
            "Kita butuh lokasi dikit biar tau venue mana yang deket sama kamu. Gak bakal kita track 24 jam kok.",
          ),
          _PrivacyItem(
            "5. Keamanan",
            "Sistem kita udah dipagerin pake teknologi kekinian. InsyaAllah aman sentosa.",
          ),
          SizedBox(height: 20),
          Text(
            "Jadi santai aja, main bola/futsal fokus nyetak gol, urusan data biar kita yang jagain.",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final String title;
  final String content;
  const _PrivacyItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(content, style: TextStyle(color: Colors.grey[700], height: 1.5)),
        ],
      ),
    );
  }
}

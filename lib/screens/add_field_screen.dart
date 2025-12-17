import 'package:flutter/material.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';

class AddFieldScreen extends StatefulWidget {
  final Venue targetVenue;

  const AddFieldScreen({required this.targetVenue, super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sportTypeController = TextEditingController();

  bool _isLoading = false;
  final Color primaryColor = const Color(0xFF22c55e);

  Future<void> _submitField() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool success = await ApiService.addField(
        venueId: widget.targetVenue.id,
        name: _nameController.text,
        sportType: _sportTypeController.text,
        price: double.parse(_priceController.text),
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lapangan berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menambahkan lapangan. Cek koneksi server.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Lapangan di ${widget.targetVenue.name}'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Detail Lapangan Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lapangan (e.g., Lapangan A Vinyl)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.grass),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lapangan wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _sportTypeController,
                decoration: InputDecoration(
                  labelText: 'Jenis Olahraga (e.g., Futsal, Basket)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.sports),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis olahraga wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Jam (Rp)',
                  hintText: 'Cth: 120000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi.';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Masukkan angka harga yang valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submitField,
                      icon: const Icon(Icons.save),
                      label: const Text('SIMPAN LAPANGAN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

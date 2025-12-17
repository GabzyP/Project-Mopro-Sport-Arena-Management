// lib/screens/add_field_screen.dart

import 'package:flutter/material.dart';
import '../models/venue_model.dart'; 
import '../services/api_service.dart'; // Import ApiService

class AddFieldScreen extends StatefulWidget {
  // Menerima data Venue yang akan menjadi tempat lapangan baru
  final Venue targetVenue;

  const AddFieldScreen({required this.targetVenue, super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sportTypeController = TextEditingController(); // Untuk input jenis olahraga
  
  bool _isLoading = false;
  final Color primaryColor = const Color(0xFF22c55e); 

  Future<void> _submitField() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implementasikan metode addField di ApiService
      // Untuk sementara, kita hanya simulasi berhasil dan kembali.
      
      // Contoh Data yang akan dikirim (Anda harus membuat fungsi addField di ApiService dan PHP)
      /*
      final result = await ApiService.addField(
        widget.targetVenue.id,
        _nameController.text,
        _priceController.text,
        _sportTypeController.text,
      );
      */
      
      // --- Simulasi Hasil Berhasil (Hapus jika ApiService.addField sudah diimplementasi) ---
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulasi proses loading
      bool success = true; 
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lapangan berhasil ditambahkan!')),
          );
          // Mengembalikan 'true' agar VenueDetailAdminScreen me-refresh daftar lapangan
          Navigator.pop(context, true); 
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan lapangan.')),
          );
        }
      }
      // --- Akhir Simulasi ---


      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Form Nama Lapangan
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lapangan (e.g., Lapangan A Vinyl)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
              
              // Form Jenis Olahraga
              TextFormField(
                controller: _sportTypeController,
                decoration: InputDecoration(
                  labelText: 'Jenis Olahraga (e.g., Futsal, Basket)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

              // Form Harga per Jam
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga per Jam (Rp)',
                  hintText: 'Cth: 120000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi.';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Masukkan angka harga yang valid.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tombol Submit
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
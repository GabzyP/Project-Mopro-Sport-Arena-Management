import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/venue_model.dart';
import '../services/api_service.dart';

class EditVenueDialog extends StatefulWidget {
  final Venue venue;

  const EditVenueDialog({required this.venue, super.key});

  @override
  State<EditVenueDialog> createState() => _EditVenueDialogState();
}

class _EditVenueDialogState extends State<EditVenueDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _minPriceController;
  late TextEditingController _openTimeController;
  late TextEditingController _closeTimeController;
  late TextEditingController _sportTypeController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _addressController = TextEditingController(text: widget.venue.address);
    _minPriceController = TextEditingController(
      text: widget.venue.minPrice.toStringAsFixed(0),
    );
    _openTimeController = TextEditingController(text: widget.venue.openTime);
    _closeTimeController = TextEditingController(text: widget.venue.closeTime);
    _sportTypeController = TextEditingController(
      text: widget.venue.sportTypes.join(', '),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    bool success = await ApiService.updateVenue(
      id: widget.venue.id,
      name: _nameController.text,
      address: _addressController.text,
      openTime: _openTimeController.text,
      closeTime: _closeTimeController.text,
      minPrice: _minPriceController.text,
      sportType: _sportTypeController.text,
      imageFile: _imageFile,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Venue berhasil diupdate!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal update venue"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Edit Venue",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : (widget.venue.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.venue.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child: _imageFile == null && widget.venue.imageUrl.isEmpty
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              if (_imageFile == null && widget.venue.imageUrl.isNotEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Tap gambar untuk ubah",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Venue",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _minPriceController,
                decoration: const InputDecoration(
                  labelText: "Harga Mulai (Rp)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _openTimeController,
                      decoration: const InputDecoration(
                        labelText: "Buka",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _closeTimeController,
                      decoration: const InputDecoration(
                        labelText: "Tutup",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sportTypeController,
                decoration: const InputDecoration(
                  labelText: "Tipe Olahraga",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22c55e),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok6_sportareamanagement/models/venue_model.dart';
import 'package:kelompok6_sportareamanagement/services/api_service.dart';

class EditFieldDialog extends StatefulWidget {
  final Field field;

  const EditFieldDialog({required this.field, super.key});

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _sportTypeController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field.name);
    _priceController = TextEditingController(
      text: widget.field.pricePerHour.toString(),
    );
    _sportTypeController = TextEditingController(text: widget.field.sportType);
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

    bool success = await ApiService.updateField(
      id: widget.field.id,
      name: _nameController.text,
      price: _priceController.text,
      sportType: _sportTypeController.text,
      imageFile: _imageFile,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lapangan berhasil diupdate!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal update lapangan"),
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
                "Edit Lapangan",
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
                        : (widget.field.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(widget.field.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child: _imageFile == null && widget.field.imageUrl.isEmpty
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              if (_imageFile == null && widget.field.imageUrl.isNotEmpty)
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
                  labelText: "Nama Lapangan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Harga per Jam (Rp)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sportTypeController,
                decoration: const InputDecoration(
                  labelText: "Jenis Olahraga",
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

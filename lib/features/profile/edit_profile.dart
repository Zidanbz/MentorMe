// Lokasi: features/profile/ui/edit_profile_screen.dart (atau lokasi file Anda)

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mentorme/features/profile/services/profile_api_service.dart';
import 'package:mentorme/models/Profile_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = true;
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  /// [PERBAIKAN]
  /// Fungsi ini sekarang menggunakan Profile.fromJson untuk mem-parsing data
  /// dengan cara yang aman dan konsisten.
  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ProfileApiService.fetchProfile();
      if (mounted) {
        if (response.success && response.data != null) {
          // Gunakan factory fromJson yang sudah diperbaiki
          final profile = Profile.fromJson(response.data!);
          print('--- PROSES SET STATE ---');
          print('Nama dari Model: ${profile.fullName}');
          print('Telepon dari Model: ${profile.phone}');
          print('Gambar dari Model: ${profile.picture}');
          print('------------------------');

          setState(() {
            _profile = profile;
            _nameController.text = profile.fullName;
            _phoneController.text = profile.phone ?? '';
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat profil: ${response.message}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat profil: $e')),
        );
      }
    }
  }

  /// [PERBAIKAN]
  /// Logika penyimpanan tetap sama, namun sekarang kita panggil _fetchProfile
  /// setelah berhasil untuk me-refresh data di UI.
  Future<void> _editProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await ProfileApiService.updateProfile(
          fullName: _nameController.text,
          phone: _phoneController.text,
          imagePath: _image?.path,
        );

        if (mounted) {
          if (response.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil berhasil diperbarui')),
            );
            // Panggil ulang fetchProfile untuk refresh UI dengan data baru
            await _fetchProfile();
          } else {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Gagal menyimpan profil: ${response.message}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terjadi kesalahan: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF40B59F)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Foto Profile',
                      style: TextStyle(color: Color(0xFF40B59F), fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _image != null
                              ? FileImage(_image!) as ImageProvider
                              : (_profile != null &&
                                      _profile!.picture.isNotEmpty)
                                  ? NetworkImage(_profile!.picture)
                                  : null,
                          child: (_image == null &&
                                  (_profile == null ||
                                      _profile!.picture.isEmpty))
                              ? const Icon(Icons.camera_alt,
                                  size: 30, color: Colors.grey)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Nomor Telepon',
                      controller: _phoneController,
                      required: true,
                      prefixText: '+62 ',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _editProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF40B59F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? prefixText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${required ? "*" : ""}',
          style: const TextStyle(color: Color(0xFF40B59F), fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixText: prefixText,
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF40B59F)),
            ),
          ),
          validator: required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '$label tidak boleh kosong';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}

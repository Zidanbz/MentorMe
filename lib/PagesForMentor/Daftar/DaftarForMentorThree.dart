import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentorme/PagesForMentor/Daftar/AgreementPage.dart';

class UploadFotoPage extends StatefulWidget {
  const UploadFotoPage({Key? key}) : super(key: key);

  @override
  _UploadFotoPageState createState() => _UploadFotoPageState();
}

class _UploadFotoPageState extends State<UploadFotoPage> {
  String? _imagePath;
  String? _cvPath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          if (type == 'foto') {
            _imagePath = pickedImage.path;
          } else if (type == 'cv') {
            _cvPath = pickedImage.path;
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // Tampilkan pesan error ke pengguna (misalnya, menggunakan SnackBar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0FFF3),
        title: LinearProgressIndicator(
          value: 0.7,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3DD598)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Upload Foto Kamu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery, 'foto'),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: _imagePath != null
                          ? DecorationImage(
                              image: FileImage(File(_imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imagePath == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Scan CV Kamu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery, 'cv'),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      image: _cvPath != null
                          ? DecorationImage(
                              image: FileImage(File(_cvPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _cvPath == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Link Portofolio (Opsional)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan Link Portofolio',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 120), // Beri ruang untuk tombol
              ],
            ),
            Positioned(
              // Posisikan tombol
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0XFF339989)),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  textStyle: WidgetStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 18)),
                  foregroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xffffffff)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgreementPage()),
                  );
                  // Aksi ketika tombol "Next" ditekan
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

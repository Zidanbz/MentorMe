import 'dart:io'; // Import dart:io untuk FileImage
import 'package:flutter/material.dart';
import 'package:mentorme/PagesForMentor/Daftar/DaftarForMentorThree.dart';

class Daftarformentortwo extends StatefulWidget {
  const Daftarformentortwo({Key? key}) : super(key: key);

  @override
  State<Daftarformentortwo> createState() => _DaftarformentortwoState();
}

class _DaftarformentortwoState extends State<Daftarformentortwo> {
  String? _imagePath;

// gw belom selesaiin bingung gw



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFE0FFF3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE0FFF3),
          title: LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff3DD598)),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Scan Foto KTP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    // onTap: imagem,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        image: _imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(_imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Center(
                        child: _imagePath != null
                            ? Image.file(File(_imagePath!))
                            : const Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NO KTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'No. KTP',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0XFF339989)),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30)),
                    textStyle: WidgetStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 18)),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xffffffff)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadFotoPage()),
                    );
                    // Aksi ketika tombol "Next" ditekan
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

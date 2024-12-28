import 'package:flutter/material.dart';
import 'dart:convert';

class DetailProjectPage extends StatelessWidget {
  final Map<String, dynamic> project;

  const DetailProjectPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Project
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                project['materialName'] ?? 'Project Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ringkasan
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RINGKASAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project['summary'] ??
                        'HTML (Hypertext Markup Language) adalah bahasa markup standar yang digunakan untuk membuat dan merancang halaman web. Dalam kursus ini, melalui pengenalan ini, Anda akan mempelajari tentang HTML.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Video Pengantar
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Video Pengantar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: project['picture'] != null
                            ? MemoryImage(base64Decode(project['picture']))
                            : const AssetImage(
                                    'assets/images/video_placeholder.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Profil Mentor
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profil Mentor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    project['mentorProfile'] ??
                        'Aria merupakan seorang Software Engineer dengan keahlian pada bidang web development. Belum mempunyai pengalaman di bidang pengembangan web dan teknologi.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Tombol Beli Project
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  // Implementasi pembelian project
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff339989),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Beli Project - Rp ${project['price'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

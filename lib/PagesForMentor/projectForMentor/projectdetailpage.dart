import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> projectData;

  const ProjectDetailPage({Key? key, required this.projectData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Project'),
        backgroundColor: const Color(0xFFE0FFF3),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar Project
            Image.asset(
              projectData['gambar'] ?? 'Logo.png',
              height: 200,
              fit: BoxFit.cover,
            ),

            // Informasi Project
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Project
                  Text(
                    projectData['judul'] ?? 'Judul Project',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Harga Project
                  Text(
                    projectData['harga'] != null
                        ? 'Rp. ${projectData['harga']}'
                        : 'Rp. 250.000',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ringkasan Project
                  const Text(
                    'RINGKASAN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    projectData['deskripsi'] ??
                        'Deskripsi Project: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et orci nec ante dignissim finibus. Maecenas a ex tincidunt, ultrices felis eget, tincidunt lacus.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Video Pengantar
                  const Text(
                    'Video Pengantar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TODO: Implementasi video player di sini
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.play_circle_outline, size: 50),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tentang Mentor
                  const Text(
                    'Tentang Mentor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TODO: Ganti dengan data mentor dari projectData
                  const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/Logo.png'),
                    ),
                    title: Text('Nama Mentor'),
                    subtitle: Text('Deskripsi Mentor'),
                  ),
                  const SizedBox(height: 16),

                  // Materi Pembelajaran
                  const Text(
                    'Materi Pembelajaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TODO: Implementasi list materi pembelajaran di sini
                  const Text('Daftar materi pembelajaran...'),

                  // Tombol Edit Project (opsional)
                  ElevatedButton(
                    onPressed: () {
                      // Aksi ketika tombol "Edit Project" ditekan
                      // ...
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff27DEBF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Edit Project"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

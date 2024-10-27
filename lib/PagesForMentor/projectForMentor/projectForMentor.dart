import 'package:flutter/material.dart';
import 'package:mentorme/PagesForMentor/projectForMentor/uploadProject.dart';

class ProjectForMentorPage extends StatefulWidget {
  const ProjectForMentorPage({super.key});

  @override
  State<ProjectForMentorPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectForMentorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PROJECTKU',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahProjectPage()),
          );
          // Aksi ketika tombol ditekan, misalnya, navigasi ke halaman upload project
        },
        backgroundColor: const Color(0xff2ECC71),
        child: const Icon(Icons.upload),
      ),
    );
  }

  Widget _buildProjectCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail project
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 127,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tampilkan data project (judul, dll.)
                Text(
                  'Judul Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}

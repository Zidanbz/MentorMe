import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart'; // Sesuaikan dengan path yang benar
import 'dart:convert';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar project
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: project['picture'] != null
                  ? Image.memory(
                      base64Decode(project['picture']), // Decode base64 image
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 50),
                        );
                      },
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
            ),
            const SizedBox(height: 16),
            // Nama material
            Text(
              project['materialName'] ?? 'Untitled',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    Color(0xff339989), // Sesuaikan dengan warna tema aplikasi
              ),
            ),
            const SizedBox(height: 8),
            // Nama mentor
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Mentor: ${project['fullName'] ?? 'Unknown'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Jumlah siswa dan harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${project['student'] ?? 0} Students',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Rp ${project['price']?.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      ) ?? '0'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff339989), // Sesuaikan dengan warna tema
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return Scaffold(
          backgroundColor:
              const Color(0xffE0FFF3), // Sesuaikan dengan warna tema
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'PROJECTS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: projectProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff339989),
                        ),
                      )
                    : projectProvider.projects.isEmpty
                        ? const Center(
                            child: Text(
                              'No projects available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: projectProvider.projects.length,
                            itemBuilder: (context, index) {
                              return _buildProjectCard(
                                  projectProvider.projects[index]);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

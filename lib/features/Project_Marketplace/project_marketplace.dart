import 'package:flutter/material.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/Project_Marketplace/detail_project_markertplace.dart';
import 'package:mentorme/providers/getProject_provider.dart'; // Tambahkan import ini
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Set<String> purchasedProjectIds =
      {}; // Menyimpan ID project yang sudah dibeli
  bool isLoadingLearning = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetProjectProvider>(context, listen: false)
          .fetchAllProjects();
      await loadLearningData();
    });
  }

  Future<void> loadLearningData() async {
    try {
      final learningData = await ActivityService.fetchLearningData();
      setState(() {
        purchasedProjectIds = learningData
            .map((learning) => learning['IDProject']?.toString() ?? '')
            .toSet();
        isLoadingLearning = false;
      });
      developer.log('Purchased Projects: $purchasedProjectIds');
    } catch (e) {
      developer.log('Error loading learning data: $e');
      setState(() {
        isLoadingLearning = false;
      });
    }
  }

  Widget _buildProjectCard(
      BuildContext context, Map<String, dynamic> projectData) {
    final String projectId = projectData['ID'].toString();
    final bool isPurchased = purchasedProjectIds.contains(projectId);
    developer.log('Project Data: ${projectData.toString()}');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProjectmarketplacePage(
              projectId: projectData,
            ),
          ),
        );
      },
      child: Card(
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
                child: projectData['picture'] != null
                    ? Image.network(
                        projectData['picture'],
                        height: 200,
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
                projectData['materialName'] ?? 'Untitled',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff339989),
                ),
              ),
              const SizedBox(height: 8),
              // Nama mentor
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Mentor: ${projectData['mentor'] ?? 'Unknown'}',
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
                      const Icon(Icons.school, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        projectData['learningMethod'] ?? 'Untitled',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Rp ${projectData['price']?.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]}.',
                        ) ?? '0'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff339989),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isPurchased)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Sudah Dibeli',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetProjectProvider>(
      builder: (context, GetProjectProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffE0FFF3),
          body: isLoadingLearning
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff339989),
                  ),
                )
              : Column(
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
                      child: GetProjectProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff339989),
                              ),
                            )
                          : GetProjectProvider.projects.isEmpty
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
                                  itemCount: GetProjectProvider.projects.length,
                                  itemBuilder: (context, index) {
                                    return _buildProjectCard(
                                      context,
                                      GetProjectProvider.projects[index],
                                    );
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

import 'package:flutter/material.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/beranda/detail_project_inLearnPath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';

class ProjectPageInLearningPath extends StatefulWidget {
  const ProjectPageInLearningPath({Key? key, required this.learningPathId})
      : super(key: key);

  final learningPathId;

  @override
  State<ProjectPageInLearningPath> createState() =>
      _ProjectPageInLearningPathState();
}

class _ProjectPageInLearningPathState extends State<ProjectPageInLearningPath> {
  Set<String> purchasedProjectIds = {};
  bool isLoadingLearning = true;

  @override
  void initState() {
    super.initState();
    loadLearningData();
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
    } catch (e) {
      setState(() {
        isLoadingLearning = false;
      });
    }
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final projectId = project['ID']?.toString() ?? '';
    final isPurchased = purchasedProjectIds.contains(projectId);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProjectPage(project: project),
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
              // Gambar project dari URL
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: project['picture'] != null
                    ? Image.network(
                        project['picture'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50),
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
                      const Icon(Icons.school, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        project['learningMethod'] ?? 'Untitled',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
                      color: Color(0xff339989),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Label jika sudah dibeli
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
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffE0FFF3),
          appBar: AppBar(
            backgroundColor: const Color(0xff27DEBF),
            title: const Text('Projects'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
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
                child: projectProvider.isLoading || isLoadingLearning
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xff339989)),
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
                                context,
                                projectProvider.projects[index],
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

import 'package:flutter/material.dart';
import 'package:mentorme/features/beranda/project_inlearningpath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';

class BerandaPage extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> learningPaths;
  final Function(int) onTabChange;

  const BerandaPage({
    super.key,
    required this.categories,
    required this.learningPaths,
    required this.onTabChange,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'BERANDA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Learning Path',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: widget.learningPaths.length,
                      itemBuilder: (context, index) {
                        final learningPath = widget.learningPaths[index];

                        // Pastikan learningPathId adalah String
                        final learningPathId =
                            learningPath['ID']?.toString() ?? '';
                        final learningPathName =
                            learningPath['name'] ?? 'Learning Path';
                        final pictureUrl = learningPath['picture'] ?? '';

                        return InkWell(
                          onTap: () {
                            if (learningPathId.isNotEmpty) {
                              // Set selected LearningPathId sebelum navigasi
                              Provider.of<ProjectProvider>(context,
                                      listen: false)
                                  .setSelectedLearningPathId(learningPathId);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProjectPageInLearningPath(
                                    learningPathId: learningPathId,
                                  ),
                                ),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(7)),
                                    child: pictureUrl.isNotEmpty
                                        ? Image.network(
                                            pictureUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.broken_image,
                                                  size: 48,
                                                  color: Colors.grey);
                                            },
                                          )
                                        : const Icon(Icons.image, size: 48),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    learningPathName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

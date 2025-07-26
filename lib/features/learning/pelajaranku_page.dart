import 'package:flutter/material.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/learning/detail_pelajaranku.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';
import 'package:mentorme/shared/widgets/optimized_list_view.dart';

class Kegiatanku extends StatefulWidget {
  const Kegiatanku({super.key});

  @override
  State<Kegiatanku> createState() => _KegiatankuState();
}

class _KegiatankuState extends State<Kegiatanku> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);
  static const Color accentColor = Color(0xff27DEBF);

  int _currentIndex = 0;
  List<dynamic> _progressCourses = [];
  List<dynamic> _completedCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // --- LOGIC (No Changes Needed) ---
  @override
  void initState() {
    super.initState();
    _loadLearningData();
  }

  Future<void> _loadLearningData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final learningData = await ActivityService.fetchLearningData();
      List<dynamic> progressCourses = [];
      List<dynamic> completedCourses = [];

      for (var item in learningData) {
        String idProject = item['ID'];
        if (idProject.isNotEmpty) {
          final progress =
              await ActivityService.fetchActivityProgress(idProject);
          item['progress'] = progress;

          if (progress >= 1.0) {
            completedCourses.add(item);
          } else {
            progressCourses.add(item);
          }
        }
      }

      if (mounted) {
        setState(() {
          _progressCourses = progressCourses;
          _completedCourses = completedCourses;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Gagal memuat data kegiatanmu.";
        });
      }
    }
  }

  // --- UI WIDGETS (New and Improved) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Kegiatanku",
          style: TextStyle(
            color: darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabSwitcher(),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                      ? _buildErrorState(_errorMessage)
                      : OptimizedFadeSlide(
                          duration: const Duration(milliseconds: 600),
                          child: _buildCurrentList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildTabButton("Dalam Progress", 0),
          _buildTabButton("Selesai", 1),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : darkTextColor.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentList() {
    final list = _currentIndex == 0 ? _progressCourses : _completedCourses;
    if (list.isEmpty) {
      return _currentIndex == 0
          ? _buildEmptyState(
              imagePath: 'assets/Maskot.png',
              message: "Kamu belum memiliki kursus aktif.\nAyo mulai belajar!",
            )
          : _buildEmptyState(
              icon: Icons.check_circle_outline,
              message: "Belum ada kursus yang kamu selesaikan.",
            );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(list[index]);
      },
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    String? rawImageUrl = course['project']?['picture'];
    String? imageUrl;

    if (rawImageUrl != null && rawImageUrl.isNotEmpty) {
      // --- LOGIKA PERBAIKAN URL ---
      // Ambil bagian terakhir dari URL setelah 'storage.googleapis.com'.
      // Ini efektif untuk menangani URL yang benar maupun yang dobel.
      final path = rawImageUrl.split('storage.googleapis.com').last;

      // Gabungkan kembali menjadi URL yang valid dan bersih.
      imageUrl = 'https://storage.googleapis.com$path';
    }

    double progressValue = (course['progress'] as num?)?.toDouble() ?? 0.0;
    bool isCompleted = progressValue >= 1.0;

    return OptimizedFadeSlide(
        delay: Duration(milliseconds: 100),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailKegiatan(activityId: course['ID'] ?? ''),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shadowColor: primaryColor.withOpacity(0.2),
            margin: const EdgeInsets.only(bottom: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Background Image
                if (imageUrl != null)
                  OptimizedImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: ShimmerCard(
                      width: double.infinity,
                      height: 200,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    errorWidget: _buildImagePlaceholder(),
                  )
                else
                  _buildImagePlaceholder(),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['project']['materialName'] ?? 'Tanpa Judul',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                            shadows: [
                              Shadow(blurRadius: 2, color: Colors.black54)
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        isCompleted
                            ? const Chip(
                                avatar: Icon(Icons.check_circle,
                                    color: Colors.white, size: 16),
                                label: Text('Selesai'),
                                backgroundColor: primaryColor,
                                labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progressValue,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.3),
                                        color: accentColor,
                                        minHeight: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(progressValue * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        _buildTabSwitcher(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ShimmerCard(
                  width: double.infinity,
                  height: 200,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 200,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.photo_size_select_actual_rounded,
            color: Colors.grey, size: 50),
      ),
    );
  }

  Widget _buildEmptyState(
      {String? imagePath, IconData? icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(imagePath, height: 150)
          else if (icon != null)
            Icon(icon, size: 100, color: darkTextColor.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16, color: darkTextColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 50), // Extra space at the bottom
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            'Oops, Terjadi Kesalahan',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: darkTextColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}

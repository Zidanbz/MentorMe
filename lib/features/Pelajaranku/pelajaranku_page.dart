import 'package:flutter/material.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/Pelajaranku/detail_pelajaranku.dart';

class Kegiatanku extends StatefulWidget {
  const Kegiatanku({super.key});

  @override
  State<Kegiatanku> createState() => _KegiatankuState();
}

class _KegiatankuState extends State<Kegiatanku> {
  int _currentIndex = 0;
  List<dynamic> _progressCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

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

      List<Map<String, dynamic>> progressCourses = [];

      for (var item in learningData) {
        String idProject = item['ID'];

        if (idProject.isNotEmpty) {
          final progress =
              await ActivityService.fetchActivityProgress(idProject);
          item['progress'] = progress;
          progressCourses.add(item);
        }
      }

      setState(() {
        _progressCourses = progressCourses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan saat mengambil data.";
      });
    }
  }

  void _onButtonPressed(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _currentIndex == 0
                          ? _buildProgressList()
                          : _buildCompletedList(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kegiatanku",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton("Progress", 0),
              const SizedBox(width: 8),
              _buildTabButton("Selesai", 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(index),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(165, 35),
        backgroundColor:
            _currentIndex == index ? const Color(0xff27DEBF) : null,
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgressList() {
    if (_progressCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Maskot.png', height: 150),
            const SizedBox(height: 16),
            const Text(
              "Kamu belum membeli course",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _progressCourses.length,
      itemBuilder: (context, index) {
        var course = _progressCourses[index];
        return _buildCard(course);
      },
    );
  }

  Widget _buildCompletedList() {
    return const Center(
      child: Text(
        "Belum ada course yang selesai",
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> learning) {
    String? rawImageUrl = learning['project']?['picture'];
    String? imageUrl;

    if (rawImageUrl != null && rawImageUrl.isNotEmpty) {
      // Perbaiki URL yang double
      if (rawImageUrl.contains('https://storage.googleapis.com')) {
        int index = rawImageUrl.indexOf('https://storage.googleapis.com', 1);
        if (index != -1) {
          imageUrl = rawImageUrl.substring(index);
        } else {
          imageUrl = rawImageUrl;
        }
      } else {
        imageUrl = rawImageUrl;
      }
    }

    double progressValue = learning['progress'] ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailKegiatan(activityId: learning['ID'] ?? ''),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image,
                          size: 48, color: Colors.grey);
                    },
                  )
                : Container(height: 200, color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    learning['project']['materialName'] ?? 'Tidak ada judul',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xff27DEBF),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progressValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
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

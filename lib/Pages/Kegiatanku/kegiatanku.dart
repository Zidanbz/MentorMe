import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mentorme/Pages/Kegiatanku/detail_kegiatan.dart';
import 'package:mentorme/global/global.dart';

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
    _fetchLearningData();
  }

  Future<void> _fetchLearningData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/my/learning'),
        headers: {'Authorization': 'Bearer $currentUserToken'},
      );

      print("Response dari API: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['data'] != null &&
          data['data'] is Map &&
          data['data'].containsKey('learning')) {
        List<dynamic> learningData = data['data']['learning'];
        List<Map<String, dynamic>> progressCourses = [];

        for (var item in learningData) {
          String idProject = item['ID'];

          if (idProject.isNotEmpty) {
            final progress = await _fetchActivityProgress(idProject);
            item['progress'] =
                progress; // Simpan progress di item, bukan trainActivity
            progressCourses.add(item);
          }
        }

        setState(() {
          _progressCourses = progressCourses;
          _isLoading = false;
        });
      } else {
        print("Error: data['data'] tidak sesuai format.");
        setState(() {
          _isLoading = false;
          _errorMessage = "Gagal memuat data.";
        });
      }
    } catch (e) {
      print('Error fetching learning data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan. Coba lagi nanti.";
      });
    }
  }

  Future<double> _fetchActivityProgress(String idProject) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://widgets-catb7yz54a-uc.a.run.app/api/my/activity/$idProject'),
        headers: {'Authorization': 'Bearer $currentUserToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final activities = data['data'];

        int totalActivities = activities.length;
        int completedActivities =
            activities.where((a) => a['status'] == 'true').length;

        return totalActivities > 0
            ? completedActivities / totalActivities
            : 0.0;
      }
    } catch (e) {
      // print('Error fetching activity progress: $e');
    }
    return 0.0;
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
            Image.asset(
              'assets/Maskot.png',
              height: 150,
            ),
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
    Uint8List? imageBytes;
    if (learning['project']['picture'] != null) {
      try {
        imageBytes = base64Decode(learning['project']['picture']);
      } catch (e) {
        // print("Error decoding image: $e");
      }
    }

    double progressValue = learning['status'] ?? 0.0;

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
            imageBytes != null
                ? Image.memory(imageBytes,
                    height: 180, width: double.infinity, fit: BoxFit.cover)
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
                  // Enhanced LinearProgressIndicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: Colors.grey[300],
                        color: const Color(0xff27DEBF),
                        minHeight: 8, // Increased height for visibility
                      ),
                      const SizedBox(
                          height: 4), // Space between progress bar and text
                      Text(
                        '${(progressValue * 100).toStringAsFixed(0)}%', // Display percentage
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
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

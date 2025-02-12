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
  List<dynamic> _completedCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchLearningData();
  }

  Future<void> _fetchLearningData() async {
    try {
      final response = await http.get(
        Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/my/learning'),
        headers: {
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data dari API: ${data['data']}'); // Log data dari API

        if (data['data'] != null && data['data']['learning'] != null) {
          setState(() {
            _progressCourses = data['data']['learning']
                .where((course) => course['progress'] == true)
                .toList();
            _completedCourses = data['data']['learning']
                .where((course) => course['progress'] == false)
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Data tidak ditemukan';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  void _onButtonPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kegiatanku",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _onButtonPressed(0),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(165, 35),
                                  backgroundColor: _currentIndex == 0
                                      ? const Color(0xff27DEBF)
                                      : null,
                                ),
                                child: const Text(
                                  "Progress",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _onButtonPressed(1),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(165, 35),
                                  backgroundColor: _currentIndex == 1
                                      ? const Color(0xff27DEBF)
                                      : null,
                                ),
                                child: const Text(
                                  "Selesai",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _currentIndex == 0
                          ? _buildProgressList()
                          : _buildCompletedList(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildProgressList() {
    return SingleChildScrollView(
      child: Column(
        children: _progressCourses.map((course) {
          return _buildCard(
            imagePath: course['project']['picture'] ?? '', // Ambil dari API
            title: course['project']['materialName'] ?? 'Tidak ada judul',
            details: '4.7 (320 Reviews)', // Contoh detail
            additionalText: '${course['student'] ?? 0} students',
            progress: 0.7, // Contoh progress
            showProgress: true,
            course: course,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompletedList() {
    return SingleChildScrollView(
      child: Column(
        children: _completedCourses.map((course) {
          return _buildCard(
            imagePath: course['project']['picture'] ?? '', // Ambil dari API
            title: course['project']['materialName'] ?? 'Tidak ada judul',
            details: '4.8 (200 Reviews)', // Contoh detail
            additionalText: '${course['student'] ?? 0} students',
            progress: 1.0, // Progress selesai
            showProgress: false,
            course: course,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String title,
    required String details,
    required String additionalText,
    required double progress,
    required bool showProgress,
    required Map<String, dynamic> course,
  }) {
    // Decode base64 image jika perlu
    Uint8List imageBytes = base64Decode(imagePath);

    return GestureDetector(
      onTap: () {
        final String activityId = course['ID'] ?? '';
        print("Data course: $course");
        print("Course ID: ${course['IDProject']}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKegiatan(
              activityId: activityId,
            ), // Pass ID
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(imageBytes,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover), // Menampilkan gambar
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              details,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.supervised_user_circle_outlined,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              additionalText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        if (showProgress) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 300,
                            height: 7,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              color: const Color(0xff27DEBF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(progress * 100).toInt()}% Complete',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

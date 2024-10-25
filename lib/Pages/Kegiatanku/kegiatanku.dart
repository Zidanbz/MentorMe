import 'package:flutter/material.dart';

class Pelajaranku extends StatefulWidget {
  const Pelajaranku({super.key});

  @override
  State<Pelajaranku> createState() => _PelajarankuState();
}

class _PelajarankuState extends State<Pelajaranku> {
  int _currentIndex = 0;

  // List of texts for each card
  final List<String> _titles = [
    'PEMOGRAMAN WEB',
    'DATA ANALYST',
    'JARINGAN KOMPUTER',
    'STATISTIKA',
  ];

  final List<String> _details = [
    '4.7 (320 Reviews)',
    '4.7 (320 Reviews)',
    '4.7 (320 Reviews)',
    '4.7 (320 Reviews)',
  ];

  final List<String> _additionalTexts = [
    '1.122 students',
    '1.122 students',
    '1.122 students',
    '1.122 students',
  ];

  // List of progress percentages for each card
  final List<double> _progressValues = [
    0.7, // 70% progress
    0.5, // 50% progress
    0.8, // 80% progress
    0.3, // 30% progress
  ];

  // Dummy list of completed courses for "Selesai" tab
  final List<String> _completedCourses = [
    'MATEMATIKA DASAR',
    'BASIS DATA',
  ];

  // List data untuk "Selesai" tab
  final List<String> _completedTitles = [
    'MATEMATIKA DASAR',
    'BASIS DATA',
  ];
  final List<String> _completedDetails = [
    '4.8 (200 Reviews)',
    '4.9 (150 Reviews)',
  ];
  final List<String> _completedAdditionalTexts = [
    '2.234 students',
    '3.456 students',
  ];
  final List<double> _completedProgressValues = [
    1.0, // 100% progress
    1.0, // 100% progress
  ];

  void _onButtonPressed(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
                  "Pelajaranku",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _onButtonPressed(0),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(165, 35),
                        backgroundColor:
                            _currentIndex == 0 ? const Color(0xff27DEBF) : null,
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
                        backgroundColor:
                            _currentIndex == 1 ? const Color(0xff27DEBF) : null,
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
        children: List.generate(_titles.length, (index) {
          return _buildCard(
            imagePath: 'assets/Background.png',
            title: _titles[index],
            details: _details[index],
            additionalText: _additionalTexts[index],
            progress: _progressValues[index],
            showProgress: true,
          );
        }),
      ),
    );
  }

  Widget _buildCompletedList() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(_completedCourses.length, (index) {
          return _buildCard(
            imagePath: 'assets/Card1.png',
            title: _completedTitles[index],
            details: _completedDetails[index],
            additionalText: _completedAdditionalTexts[index],
            progress: _completedProgressValues[index],
            showProgress: false, // Tidak menampilkan progress bar
          );
        }),
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
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
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
                          width: 300, // Adjust the width here
                          height: 7, // Adjust the height here
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
    );
  }
}

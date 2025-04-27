import 'package:flutter/material.dart';
import 'package:mentorme/core/services/project_services.dart';
import 'dart:developer' as developer; // Import ProjectService
import 'package:mentorme/global/global.dart';
import 'package:mentorme/Pages/Payment/payment_detail.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailProjectmarketplacePage extends StatefulWidget {
  final Map<String, dynamic> projectId;

  const DetailProjectmarketplacePage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<DetailProjectmarketplacePage> createState() =>
      _DetailProjectPageState();
}

class _DetailProjectPageState extends State<DetailProjectmarketplacePage> {
  bool isLoading = true;
  Map<String, dynamic>? detailProject;
  YoutubePlayerController? _controller;
  Set<String> userLearningIDs = {};
  bool isLoadingLearning = true;
  bool hasProject = false;

  @override
  void initState() {
    super.initState();
    developer
        .log('DetailProjectPage initialized with project: ${widget.projectId}');
    fetchDetailProject();
    fetchUserLearningIDs();
  }

  void fetchUserLearningIDs() {
    ProjectService.fetchUserLearningIDs(currentUserToken!).then((ids) {
      setState(() {
        userLearningIDs = ids;
        isLoadingLearning = false;
        hasProject =
            userLearningIDs.contains(widget.projectId['IDProject'].toString());
        developer.log('User Learning IDs fetched');
      });
    }).catchError((error) {
      developer.log('Error fetching user learning IDs: $error');
      setState(() => isLoadingLearning = false);
    });
  }

  Future<void> fetchDetailProject() async {
    final projectId = widget.projectId['ID'];
    if (projectId == null || projectId.toString().isEmpty) {
      developer.log('Error: Project ID is missing or invalid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project ID tidak ditemukan')),
      );
      return;
    }

    try {
      final data = await ProjectService.getProjectDetail(
        projectId: projectId.toString(),
        token: currentUserToken!,
      );

      setState(() {
        detailProject = data;
        isLoading = false;

        if (detailProject?['linkVideo'] != null) {
          final videoId = YoutubePlayerController.convertUrlToId(
              detailProject!['linkVideo']);
          if (videoId != null) {
            try {
              _controller = YoutubePlayerController.fromVideoId(
                videoId: videoId,
                params: const YoutubePlayerParams(
                  showControls: true,
                  showFullscreenButton: true,
                  enableJavaScript: true,
                  playsInline: true,
                ),
              );
            } catch (e) {
              developer.log('Error initializing YouTube controller: $e');
            }
          }
        }
      });
    } catch (e) {
      developer.log('Error fetching project details: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    developer
        .log('Building DetailProjectPage with state: isLoading: $isLoading');

    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff339989)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Project
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.projectId['materialName'] ?? 'Project Title',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ringkasan
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RINGKASAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          detailProject?['info'] ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Video Pengantar
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Video Pengantar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Kotak Video
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: _controller != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: YoutubePlayer(
                                    controller: _controller!,
                                    aspectRatio: 16 / 9,
                                  ),
                                )
                              : const Center(
                                  child: Text('Video tidak tersedia'),
                                ),
                        ),
                      ],
                    ),
                  ),

                  // Profil Mentor
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profil Mentor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xff339989)),
                            const SizedBox(width: 10),
                            Text(
                              detailProject?['fullName'] ?? 'Loading...',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          detailProject?['about'] ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Jumlah Siswa
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     children: [
                  //       const Icon(Icons.people, color: Color(0xff339989)),
                  //       const SizedBox(width: 10),
                  //       // Text(
                  //       //   '${detailProject?['student'] ?? 0} Students',
                  //       //   style: const TextStyle(
                  //       //     fontSize: 16,
                  //       //     fontWeight: FontWeight.bold,
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),

                  // Tombol Beli Project
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Tombol Beli Project
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentDetailPage(
                                    projectId:
                                        widget.projectId['ID'].toString(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff339989),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Beli Project - Rp ${widget.projectId['price'] ?? 0}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol Lihat Project Saya
                        if (hasProject == true)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Aksi ketika tombol "Lihat Project Saya" ditekan
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Lihat Project Saya',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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

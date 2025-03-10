import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:mentorme/global/global.dart';
import 'package:mentorme/Pages/Payment/payment_detail.dart';

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

  @override
  void initState() {
    super.initState();
    developer
        .log('DetailProjectPage initialized with project: ${widget.projectId}');
    fetchDetailProject();
  }

  @override
  void dispose() {
    developer.log('Disposing DetailProjectPage');
    _controller?.close();
    super.dispose();
  }

  Future<bool> refreshToken() async {
    try {
      return false;
    } catch (e) {
      developer.log('Error refreshing token: $e');
      return false;
    }
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
      // developer.log('Fetching project with ID: ${widget.projectId['id']}');
      // developer.log('Using token: $currentUserToken');

      final response = await http.get(
        Uri.parse(
            'https://widgets-catb7yz54a-uc.a.run.app/api/learn/project/${widget.projectId['ID']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
      );

      developer.log('Response status code: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('Parsed data: $data');

        setState(() {
          detailProject = data['data'];
          isLoading = false;

          if (detailProject?['linkVideo'] != null) {
            final videoId = YoutubePlayerController.convertUrlToId(
              detailProject!['linkVideo'],
            );
            developer.log('Extracted YouTube video ID: $videoId');

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

                developer.log('YouTube controller initialized successfully');
              } catch (e) {
                developer.log('Error initializing YouTube controller: $e');
              }
            }
          }
        });
      } else if (response.statusCode == 401) {
        // Try to refresh token first
        final refreshed = await refreshToken();
        if (refreshed) {
          // Retry fetch with new token
          fetchDetailProject();
          return;
        } else {
          throw Exception('Unauthorized access');
        }
      } else {
        developer.log('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load project details');
      }
    } catch (e, stackTrace) {
      developer.log('Error in fetchDetailProject:',
          error: e, stackTrace: stackTrace);
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('Unauthorized')
                ? 'Sesi anda telah berakhir. Silakan login kembali.'
                : 'Terjadi kesalahan: $e',
          ),
          action: e.toString().contains('Unauthorized')
              ? SnackBarAction(
                  label: 'Login',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                )
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log('Building DetailProjectPage with state: '
        'isLoading: $isLoading, '
        'hasController: ${_controller != null}, '
        'hasDetailProject: ${detailProject != null}');

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
              child: CircularProgressIndicator(
              color: Color(0xff339989),
            ))
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                  // Video Pengantar
                  Container(
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
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.black87, // Background gelap
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20), // Padding untuk frame gelap
                            child: _controller != null
                                ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Center(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6, // Ukuran video lebih kecil
                                          maxHeight: 250,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: YoutubePlayer(
                                            controller: _controller!,
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[
                                          800], // Warna placeholder lebih gelap
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Video tidak tersedia',
                                            style: TextStyle(
                                                color:
                                                    Colors.white), // Teks putih
                                          ),
                                          if (detailProject?['linkVideo'] !=
                                              null)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Link: ${detailProject!['linkVideo']}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .white70, // Teks putih transparan
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.people, color: Color(0xff339989)),
                        const SizedBox(width: 10),
                        Text(
                          '${detailProject?['student'] ?? 0} Students',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Beli Project
                  // Di detail-project.dart, bagian tombol Beli Project
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentDetailPage(
                              projectId: widget.projectId['ID']
                                  .toString(), // Sesuaikan dengan nama field yang benar
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
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:mentorme/core/services/project_services.dart';
import 'package:mentorme/global/global.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:mentorme/Pages/Payment/payment_detail.dart';

class DetailProjectPage extends StatefulWidget {
  final Map<String, dynamic> project;

  const DetailProjectPage({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<DetailProjectPage> createState() => _DetailProjectPageState();
}

class _DetailProjectPageState extends State<DetailProjectPage> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  bool isLoading = true;
  Map<String, dynamic>? detailProject;
  YoutubePlayerController? _controller;

  // --- LOGIC (No Changes) ---
  @override
  void initState() {
    super.initState();
    developer.log('DetailProjectPage initialized');
    fetchDetailProject();
  }

  @override
  void dispose() {
    developer.log('Disposing DetailProjectPage');
    _controller?.close();
    super.dispose();
  }

  Future<void> fetchDetailProject() async {
    try {
      developer.log('Fetching project with ID: ${widget.project['ID']}');
      final data = await ProjectService.getProjectDetail(
        projectId: widget.project['ID'].toString(),
        token: currentUserToken!,
      );

      if (mounted && data != null) {
        setState(() {
          detailProject = data;
          isLoading = false;

          if (detailProject?['linkVideo'] != null) {
            final videoId = YoutubePlayerController.convertUrlToId(
              detailProject!['linkVideo'],
            );
            developer.log('Extracted YouTube video ID: $videoId');

            if (videoId != null) {
              _controller = YoutubePlayerController.fromVideoId(
                videoId: videoId,
                params: const YoutubePlayerParams(showFullscreenButton: true),
              );
              developer.log('YouTube controller initialized successfully');
            }
          }
        });
      } else {
        developer
            .log('Failed to fetch project details or component is not mounted');
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e, stackTrace) {
      developer.log('Error in fetchDetailProject:',
          error: e, stackTrace: stackTrace);
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }
  // --- END OF LOGIC ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(child: _buildProjectHeader()),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSection(
                      title: 'Ringkasan',
                      content:
                          detailProject?['info'] ?? 'Deskripsi tidak tersedia.',
                    ),
                    _buildSection(
                      title: 'Tentang Mentor',
                      content: detailProject?['about'] ??
                          'Informasi mentor tidak tersedia.',
                      isMentorSection: true,
                      mentorName: detailProject?['fullName'],
                    ),
                    const SizedBox(height: 120), // Spacer for bottom bar
                  ]),
                )
              ],
            ),
      bottomNavigationBar: isLoading ? null : _buildBottomCtaBar(),
    );
  }

  // --- UI WIDGETS (New and Improved) ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      backgroundColor: primaryColor,
      pinned: true,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: _controller != null
            ? YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9)
            : Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, color: Colors.white54, size: 50),
                      SizedBox(height: 8),
                      Text("Video Tidak Tersedia",
                          style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.project['materialName'] ?? 'Project Title',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: darkTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                'Oleh ${detailProject?['fullName'] ?? '...'}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    bool isMentorSection = false,
    String? mentorName,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkTextColor)),
          const SizedBox(height: 12),
          if (isMentorSection) ...[
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: const Icon(Icons.person, color: primaryColor)),
                title: Text(mentorName ?? 'Nama Mentor',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Mentor Profesional'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            content,
            style: const TextStyle(
                fontSize: 14, height: 1.5, color: Colors.black54),
          ),
          const Divider(height: 32, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildBottomCtaBar() {
    // Safe price conversion
    num price = 0;
    if (widget.project['price'] is num) {
      price = widget.project['price'];
    } else if (widget.project['price'] is String) {
      price = num.tryParse(widget.project['price']) ?? 0;
    }
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(price);

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Harga',
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
              Text(
                formattedPrice,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              child: const Text('Beli Project Ini',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailPage(
                        projectId: widget.project['ID'].toString()),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

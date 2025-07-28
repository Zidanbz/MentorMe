import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/home/detail_project_inLearnPath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';

class ProjectPageInLearningPath extends StatefulWidget {
  const ProjectPageInLearningPath({Key? key, required this.learningPathId})
      : super(key: key);

  final String learningPathId;

  @override
  State<ProjectPageInLearningPath> createState() =>
      _ProjectPageInLearningPathState();
}

class _ProjectPageInLearningPathState extends State<ProjectPageInLearningPath> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  Set<String> purchasedProjectIds = {};
  bool isLoadingLearning = true;

  // --- LOGIC (Dikembalikan ke Asli) ---
  @override
  void initState() {
    super.initState();
    loadLearningData();
  }

  Future<void> loadLearningData() async {
    try {
      final learningData = await ActivityService.fetchLearningData();
      if (mounted) {
        setState(() {
          purchasedProjectIds = learningData
              .map((learning) => learning['IDProject']?.toString() ?? '')
              .toSet();
          isLoadingLearning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingLearning = false;
        });
      }
    }
  }
  // --- END OF LOGIC ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Proyek Learning Path",
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkTextColor),
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, projectProvider, child) {
          if (isLoadingLearning || projectProvider.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }
          if (projectProvider.projects.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: projectProvider.projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(
                  context, projectProvider.projects[index]);
            },
          );
        },
      ),
    );
  }

  // --- UI WIDGETS (Sesuai dengan ProjectPage sebelumnya) ---

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final String projectId = project['ID']?.toString() ?? '';
    final bool isPurchased = purchasedProjectIds.contains(projectId);

    // Logic konversi harga yang aman
    final priceData = project['price'];
    num priceAsNum = 0;
    if (priceData is num) {
      priceAsNum = priceData;
    } else if (priceData is String) {
      priceAsNum = num.tryParse(priceData) ?? 0;
    }
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(priceAsNum);

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
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            _buildCardImage(project['picture']),
            _buildGradientOverlay(),
            _buildCardContent(
              title: project['materialName'] ?? 'Untitled',
              mentor: project['fullName'] ?? 'Unknown',
            ),
            _buildPriceBadge(formattedPrice),
            _buildMethodBadge(project['learningMethod']),
            if (isPurchased) _buildPurchasedRibbon(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImage(String? imageUrl) {
    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildImagePlaceholder(),
          )
        : _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.school_outlined, size: 60, color: Colors.grey),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.black.withOpacity(0.8)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildCardContent({required String title, required String mentor}) {
    return Positioned(
      bottom: 12,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                mentor,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBadge(String price) {
    return Positioned(
      top: 12,
      left: 12,
      child: Chip(
        label: Text(price,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildMethodBadge(String? method) {
    if (method == null) return const SizedBox.shrink();
    return Positioned(
      top: 12,
      right: 12,
      child: Chip(
        label: Text(method,
            style: const TextStyle(
                color: darkTextColor, fontWeight: FontWeight.bold)),
        avatar: Icon(
            method == 'Online'
                ? Icons.videocam_rounded
                : Icons.people_alt_rounded,
            size: 16,
            color: darkTextColor),
        backgroundColor: Colors.white.withOpacity(0.9),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Widget _buildPurchasedRibbon() {
    return Positioned(
      top: -2,
      right: -2,
      child: ClipRect(
        child: Banner(
          message: "✓ Dibeli",
          location: BannerLocation.topEnd,
          color: primaryColor,
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Proyek',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkTextColor),
          ),
          const SizedBox(height: 8),
          const Text(
            'Proyek untuk learning path ini belum tersedia.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

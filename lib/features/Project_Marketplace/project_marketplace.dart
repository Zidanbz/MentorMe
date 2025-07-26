import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/Project_Marketplace/detail_project_markertplace.dart';
import 'package:mentorme/providers/getProject_provider.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  Set<String> purchasedProjectIds = {};
  bool isLoadingLearning = true;

  // --- LOGIC (No Changes) ---
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Menggunakan listen: false di initState adalah praktik yang baik
      await Provider.of<GetProjectProvider>(context, listen: false)
          .fetchAllProjects();
      await loadLearningData();
    });
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
      developer.log('Purchased Projects: $purchasedProjectIds');
    } catch (e) {
      developer.log('Error loading learning data: $e');
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
          "Project Marketplace",
          style: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<GetProjectProvider>(
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

  // --- UI WIDGETS (New and Improved) ---

  Widget _buildProjectCard(
      BuildContext context, Map<String, dynamic> projectData) {
    final String projectId = projectData['ID'].toString();
    final bool isPurchased = purchasedProjectIds.contains(projectId);

    // --- AWAL PERBAIKAN ---
    // Konversi harga dari tipe data apapun (String, int, dll) ke angka (num) dengan aman.
    final priceData = projectData['price'];
    num priceAsNum = 0; // Nilai default jika data tidak valid

    if (priceData is num) {
      // Jika sudah angka, langsung gunakan.
      priceAsNum = priceData;
    } else if (priceData is String) {
      // Jika String, coba konversi ke angka. Jika gagal, gunakan 0.
      priceAsNum = num.tryParse(priceData) ?? 0;
    }

    // Format harga yang sudah pasti berupa angka.
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(priceAsNum);
    // --- AKHIR PERBAIKAN ---

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailProjectmarketplacePage(projectId: projectData),
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
            // Gambar Background
            _buildCardImage(projectData['picture']),
            // Gradient Overlay
            _buildGradientOverlay(),
            // Konten
            _buildCardContent(
              title: projectData['materialName'] ?? 'Untitled',
              mentor: projectData['mentor'] ?? 'Unknown',
            ),
            // Lencana Harga
            _buildPriceBadge(formattedPrice),
            // Lencana Metode Belajar
            _buildMethodBadge(projectData['learningMethod']),
            // Pita "Sudah Dibeli"
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
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder();
            },
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
            'Proyek baru akan segera ditambahkan.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

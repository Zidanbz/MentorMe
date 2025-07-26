import 'package:flutter/material.dart';
import 'package:mentorme/features/beranda/project_inlearningpath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';

class BerandaPage extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> learningPaths;
  final Function(int) onTabChange;

  const BerandaPage({
    super.key,
    required this.categories,
    required this.learningPaths,
    required this.onTabChange,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

String cleanPictureUrl(String url) {
  final regex = RegExp(
      r'(https:\/\/storage\.googleapis\.com\/mentorme-aaa37\.firebasestorage\.app\/uploads\/[^\/]+\.(jpg|png|jpeg))');
  final match = regex.firstMatch(url);
  return match != null ? match.group(0)! : '';
}

class _BerandaPageState extends State<BerandaPage> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        // Menggunakan CustomScrollView agar lebih fleksibel
        child: CustomScrollView(
          slivers: [
            // Header "Selamat Datang" dihapus dari sini
            SliverToBoxAdapter(child: _buildSectionTitle("Kategori")),
            SliverToBoxAdapter(child: _buildCategoryList()),
            SliverToBoxAdapter(
                child: _buildSectionTitle("Learning Path Populer")),
            _buildLearningPathGrid(),
          ],
        ),
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkTextColor,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ActionChip(
              onPressed: () {
                widget.onTabChange(1);
              },
              label: Text(category['name'] ?? 'Kategori'),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLearningPathGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final learningPath = widget.learningPaths[index];
            return _buildLearningPathCard(learningPath);
          },
          childCount: widget.learningPaths.length,
        ),
      ),
    );
  }

  Widget _buildLearningPathCard(Map<String, dynamic> learningPath) {
    final learningPathId = learningPath['ID']?.toString() ?? '';
    final learningPathName = learningPath['name'] ?? 'Learning Path';
    final pictureUrl = cleanPictureUrl(learningPath['picture'] ?? '');

    return InkWell(
      onTap: () {
        if (learningPathId.isNotEmpty) {
          Provider.of<ProjectProvider>(context, listen: false)
              .setSelectedLearningPathId(learningPathId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProjectPageInLearningPath(learningPathId: learningPathId),
            ),
          );
        }
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: primaryColor.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            if (pictureUrl.isNotEmpty)
              Image.network(
                pictureUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
              )
            else
              _buildImagePlaceholder(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                learningPathName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.school, size: 40, color: Colors.grey),
      ),
    );
  }
}

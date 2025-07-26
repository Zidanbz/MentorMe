import 'package:flutter/material.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/features/home/project_inlearningpath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';

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

class _BerandaPageState extends State<BerandaPage> {
  bool _isLoading = false;

  String _cleanPictureUrl(String url) {
    final regex = RegExp(
        r'(https:\/\/storage\.googleapis\.com\/mentorme-aaa37\.firebasestorage\.app\/uploads\/[^\/]+\.(jpg|png|jpeg))');
    final match = regex.firstMatch(url);
    return match != null ? match.group(0)! : '';
  }

  void _navigateToLearningPath(String learningPathId) {
    if (learningPathId.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      Provider.of<ProjectProvider>(context, listen: false)
          .setSelectedLearningPathId(learningPathId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProjectPageInLearningPath(learningPathId: learningPathId),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Welcome Header
            SliverToBoxAdapter(
              child: _buildWelcomeHeader(),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: _buildSectionTitle("Kategori"),
            ),
            SliverToBoxAdapter(
              child: _buildCategoryList(),
            ),

            // Learning Paths Section
            SliverToBoxAdapter(
              child: _buildSectionTitle("Learning Path Populer"),
            ),
            _buildLearningPathGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.welcome,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai perjalanan belajar Anda hari ini!',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    if (widget.categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Tidak ada kategori tersedia',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildCategoryChip(category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> category) {
    return ActionChip(
      onPressed: () => widget.onTabChange(1),
      label: Text(
        category['name'] ?? 'Kategori',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: AppColors.background,
      elevation: 2,
      shadowColor: AppColors.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildLearningPathGrid() {
    if (widget.learningPaths.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 64,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 16),
              Text(
                'Belum ada Learning Path tersedia',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
    final pictureUrl = _cleanPictureUrl(learningPath['picture'] ?? '');

    return InkWell(
      onTap: _isLoading ? null : () => _navigateToLearningPath(learningPathId),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Optimized Background Image
            if (pictureUrl.isNotEmpty)
              OptimizedImage(
                imageUrl: pictureUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(16),
                placeholder: _buildShimmerPlaceholder(),
                errorWidget: _buildImagePlaceholder(),
              )
            else
              _buildImagePlaceholder(),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.textPrimary.withOpacity(0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: AppColors.textPrimary.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),

            // Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                learningPathName,
                style: const TextStyle(
                  color: AppColors.textLight,
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

  Widget _buildShimmerPlaceholder() {
    return const ShimmerCard(
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildImagePlaceholder({bool isLoading = false}) {
    return Container(
      color: AppColors.divider,
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColors.primary,
              )
            : const Icon(
                Icons.school_outlined,
                size: 40,
                color: AppColors.textHint,
              ),
      ),
    );
  }
}

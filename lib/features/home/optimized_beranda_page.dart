import 'package:flutter/material.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/features/home/project_inlearningpath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';
import 'package:mentorme/shared/widgets/optimized_list_view.dart';

class OptimizedBerandaPage extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> learningPaths;
  final Function(int) onTabChange;

  const OptimizedBerandaPage({
    super.key,
    required this.categories,
    required this.learningPaths,
    required this.onTabChange,
  });

  @override
  State<OptimizedBerandaPage> createState() => _OptimizedBerandaPageState();
}

class _OptimizedBerandaPageState extends State<OptimizedBerandaPage> {
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

      // Using optimized page transition
      Navigator.of(context).pushWithAnimation(
        ProjectPageInLearningPath(learningPathId: learningPathId),
        transitionType: PageTransitionType.slideRight,
        duration: const Duration(milliseconds: 300),
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
            // Welcome Header with Animation
            SliverToBoxAdapter(
              child: OptimizedFadeSlide(
                duration: const Duration(milliseconds: 600),
                child: _buildWelcomeHeader(),
              ),
            ),

            // Categories Section with Animation
            SliverToBoxAdapter(
              child: OptimizedFadeSlide(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: _buildSectionTitle("Kategori"),
              ),
            ),
            SliverToBoxAdapter(
              child: OptimizedFadeSlide(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 600),
                child: _buildCategoryList(),
              ),
            ),

            // Learning Paths Section with Animation
            SliverToBoxAdapter(
              child: OptimizedFadeSlide(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: _buildSectionTitle("Learning Path Populer"),
              ),
            ),
            _buildOptimizedLearningPathGrid(),
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
          return OptimizedFadeSlide(
            delay: Duration(milliseconds: 100 * index),
            duration: const Duration(milliseconds: 400),
            slideBegin: const Offset(0.3, 0.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildCategoryChip(category),
            ),
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

  Widget _buildOptimizedLearningPathGrid() {
    if (widget.learningPaths.isEmpty) {
      return SliverToBoxAdapter(
        child: OptimizedFadeSlide(
          delay: const Duration(milliseconds: 500),
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
            return OptimizedFadeSlide(
              delay: Duration(milliseconds: 500 + (index * 100)),
              duration: const Duration(milliseconds: 600),
              child: _buildOptimizedLearningPathCard(learningPath),
            );
          },
          childCount: widget.learningPaths.length,
        ),
      ),
    );
  }

  Widget _buildOptimizedLearningPathCard(Map<String, dynamic> learningPath) {
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

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.divider,
      child: const Center(
        child: Icon(
          Icons.school_outlined,
          size: 40,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

// Loading State untuk Beranda Page
class BerandaLoadingState extends StatelessWidget {
  const BerandaLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Welcome Header Shimmer
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerText(width: 200, height: 24),
                    const SizedBox(height: 8),
                    const ShimmerText(width: 300, height: 16),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Categories Section Shimmer
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: const ShimmerText(width: 120, height: 20),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ShimmerCard(
                        width: 100,
                        height: 40,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Learning Paths Section Shimmer
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: const ShimmerText(width: 180, height: 20),
              ),
            ),
            SliverPadding(
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
                    return const LoadingProjectCard();
                  },
                  childCount: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

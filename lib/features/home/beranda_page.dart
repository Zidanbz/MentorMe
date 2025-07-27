import 'package:flutter/material.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/features/home/project_inlearningpath.dart';
import 'package:provider/provider.dart';
import 'package:mentorme/providers/project_provider.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/global/Fontstyle.dart';

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

class _BerandaPageState extends State<BerandaPage>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -15.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

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
        enhanced.OptimizedPageRoute(
          child: ProjectPageInLearningPath(learningPathId: learningPathId),
          transitionType: enhanced.PageTransitionType.slideUp,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFFe0fff3), const Color(0xFF339989),
                      _backgroundAnimation.value * 0.3)!,
                  Color.lerp(const Color(0xFF339989), const Color(0xFFe0fff3),
                      _backgroundAnimation.value * 0.5)!,
                  Color.lerp(const Color(0xFFe0fff3), const Color(0xFF3c493f),
                      _backgroundAnimation.value * 0.2)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildFloatingElements(),
                SafeArea(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating circles with different sizes and positions
            Positioned(
              top: 80 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 150 - _floatingAnimation.value * 0.5,
              left: 20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFe0fff3).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              top: 300 + _floatingAnimation.value * 0.8,
              right: 60,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3c493f).withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 200 - _floatingAnimation.value,
              left: 40,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.08),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeHeader() {
    return enhanced.OptimizedFadeSlide(
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF339989), Color(0xFF3c493f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFe0fff3)],
                        ).createShader(bounds),
                        child: Text(
                          AppStrings.welcome,
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mulai perjalanan belajar Anda hari ini!',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tingkatkan skill Anda',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSectionTitle(String title) {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF339989), Color(0xFF3c493f)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: const Color(0xFF3c493f),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    if (widget.categories.isEmpty) {
      return enhanced.OptimizedFadeSlide(
        delay: const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF339989).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF339989).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.category_outlined,
                  color: Color(0xFF339989),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Tidak ada kategori tersedia',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF3c493f),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 300),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: widget.categories.length,
          itemBuilder: (context, index) {
            final category = widget.categories[index];
            return enhanced.OptimizedFadeSlide(
              delay: Duration(milliseconds: 100 * index),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildCategoryChip(category),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> category) {
    return enhanced.OptimizedHover(
      scale: 1.05,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFe0fff3), Colors.white],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF339989).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF339989),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              category['name'] ?? 'Kategori',
              style: AppTextStyles.labelMedium.copyWith(
                color: const Color(0xFF3c493f),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onTap: () => widget.onTabChange(1),
    );
  }

  Widget _buildLearningPathGrid() {
    if (widget.learningPaths.isEmpty) {
      return SliverToBoxAdapter(
        child: enhanced.OptimizedFadeSlide(
          delay: const Duration(milliseconds: 400),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF339989).withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                enhanced.OptimizedScale(
                  duration: const Duration(milliseconds: 800),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF339989), Color(0xFF3c493f)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Belum ada Learning Path tersedia',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: const Color(0xFF3c493f),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Learning path akan segera hadir untuk membantu perjalanan belajar Anda',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF3c493f).withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
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
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final learningPath = widget.learningPaths[index];
            return enhanced.OptimizedFadeSlide(
              delay: Duration(milliseconds: 100 * index),
              child: _buildLearningPathCard(learningPath),
            );
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

    return enhanced.OptimizedHover(
      scale: 1.03,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isLoading
                ? null
                : () => _navigateToLearningPath(learningPathId),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFe0fff3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Background Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: pictureUrl.isNotEmpty
                          ? OptimizedImage(
                              imageUrl: pictureUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: _buildShimmerPlaceholder(),
                              errorWidget: _buildImagePlaceholder(),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF3c493f).withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Loading Overlay
                  if (_isLoading)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFF3c493f).withOpacity(0.5),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF339989),
                          strokeWidth: 3,
                        ),
                      ),
                    ),

                  // Content
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF3c493f).withOpacity(0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            learningPathName,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF339989).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Mulai',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe0fff3), Color(0xFF339989)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learning Path',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

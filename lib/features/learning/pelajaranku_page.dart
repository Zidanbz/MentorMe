import 'package:flutter/material.dart';
import 'package:mentorme/core/services/kegiatanku_services.dart';
import 'package:mentorme/features/learning/detail_pelajaranku.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/optimized_list_view.dart';
import 'package:mentorme/shared/widgets/app_background.dart';
import 'package:mentorme/global/Fontstyle.dart';

class Kegiatanku extends StatefulWidget {
  const Kegiatanku({super.key});

  @override
  State<Kegiatanku> createState() => _KegiatankuState();
}

class _KegiatankuState extends State<Kegiatanku> with TickerProviderStateMixin {
  // Enhanced color palette
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);
  static const Color accentColor = Color(0xff27DEBF);

  int _currentIndex = 0;
  List<dynamic> _progressCourses = [];
  List<dynamic> _completedCourses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Enhanced animation controllers
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late AnimationController _tabController;
  late AnimationController _progressController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _tabAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadLearningData();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _tabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressController = AnimationController(
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

    _tabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tabController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    _tabController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _loadLearningData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final learningData = await ActivityService.fetchLearningData();
      List<dynamic> progressCourses = [];
      List<dynamic> completedCourses = [];

      for (var item in learningData) {
        String idProject = item['ID'];
        if (idProject.isNotEmpty) {
          final progress =
              await ActivityService.fetchActivityProgress(idProject);
          item['progress'] = progress;

          if (progress >= 1.0) {
            completedCourses.add(item);
          } else {
            progressCourses.add(item);
          }
        }
      }

      if (mounted) {
        setState(() {
          _progressCourses = progressCourses;
          _completedCourses = completedCourses;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Gagal memuat data kegiatanmu.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildEnhancedAppBar(),
              const SizedBox(height: 20),
              _buildTabSwitcher(),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _errorMessage.isNotEmpty
                        ? _buildErrorState(_errorMessage)
                        : enhanced.OptimizedFadeSlide(
                            duration: const Duration(milliseconds: 600),
                            child: _buildCurrentList(),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating learning icons
            Positioned(
              top: 100 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              top: 200 - _floatingAnimation.value * 0.5,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.book_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 150 + _floatingAnimation.value * 0.8,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnhancedAppBar() {
    return enhanced.OptimizedFadeSlide(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pelajaranku",
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: const Color(0xFF3c493f),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pantau progress belajar Anda',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF3c493f).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF339989), Color(0xFF3c493f)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTabButton("Dalam Progress", 0),
            _buildTabButton("Selesai", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    bool isActive = _currentIndex == index;
    return Expanded(
      child: enhanced.OptimizedHover(
        scale: 1.02,
        child: GestureDetector(
          onTap: () {
            setState(() => _currentIndex = index);
            _tabController.forward().then((_) => _tabController.reverse());
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [primaryColor, darkTextColor],
                    )
                  : null,
              color: isActive ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive)
                  Icon(
                    index == 0 ? Icons.hourglass_empty : Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                if (isActive) const SizedBox(width: 8),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isActive
                        ? Colors.white
                        : darkTextColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentList() {
    final list = _currentIndex == 0 ? _progressCourses : _completedCourses;
    if (list.isEmpty) {
      return _currentIndex == 0
          ? _buildEmptyState(
              imagePath: 'assets/Maskot.png',
              message: "Kamu belum memiliki kursus aktif.\nAyo mulai belajar!",
            )
          : _buildEmptyState(
              icon: Icons.check_circle_outline,
              message: "Belum ada kursus yang kamu selesaikan.",
            );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return enhanced.OptimizedFadeSlide(
              delay: Duration(milliseconds: 100 * index),
              child: _buildCourseCard(list[index], index),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course, int index) {
    String? rawImageUrl = course['project']?['picture'];
    String? imageUrl;

    if (rawImageUrl != null && rawImageUrl.isNotEmpty) {
      final path = rawImageUrl.split('storage.googleapis.com').last;
      imageUrl = 'https://storage.googleapis.com$path';
    }

    double progressValue = (course['progress'] as num?)?.toDouble() ?? 0.0;
    bool isCompleted = progressValue >= 1.0;

    return enhanced.OptimizedHover(
      scale: 1.02,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            enhanced.OptimizedPageRoute(
              child: DetailKegiatan(activityId: course['ID'] ?? ''),
              transitionType: enhanced.PageTransitionType.slideUp,
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background Image with enhanced styling
                Container(
                  height: 220,
                  width: double.infinity,
                  child: imageUrl != null
                      ? OptimizedImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          placeholder: ShimmerCard(
                            width: double.infinity,
                            height: 220,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          errorWidget: _buildImagePlaceholder(),
                        )
                      : _buildImagePlaceholder(),
                ),

                // Enhanced gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          darkTextColor.withOpacity(0.8),
                          Colors.transparent,
                          Colors.transparent,
                          primaryColor.withOpacity(0.6),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),

                // Content with enhanced styling
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['project']['materialName'] ?? 'Tanpa Judul',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                blurRadius: 4,
                                color: Colors.black54,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [primaryColor, accentColor],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Selesai',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _progressAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _progressAnimation.value,
                                        child: Text(
                                          '${(progressValue * 100).toStringAsFixed(0)}%',
                                          style:
                                              AppTextStyles.labelLarge.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      accentColor,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                // Floating action indicator
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          itemCount: 3,
          itemBuilder: (context, index) {
            return enhanced.OptimizedFadeSlide(
              delay: Duration(milliseconds: index * 100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ShimmerCard(
                  width: double.infinity,
                  height: 220,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [backgroundColor, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'Kursus',
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

  Widget _buildEmptyState({
    String? imagePath,
    IconData? icon,
    required String message,
  }) {
    return Center(
      child: enhanced.OptimizedFadeSlide(
        delay: const Duration(milliseconds: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              enhanced.OptimizedScale(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.asset(imagePath, height: 120),
                ),
              )
            else if (icon != null)
              enhanced.OptimizedScale(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, darkTextColor],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: darkTextColor,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: enhanced.OptimizedFadeSlide(
        delay: const Duration(milliseconds: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            enhanced.OptimizedScale(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: Colors.red.shade400,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Oops, Terjadi Kesalahan',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: darkTextColor.withOpacity(0.8),
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

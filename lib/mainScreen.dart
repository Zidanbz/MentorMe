// main_screen.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mentorme/features/profile/profile_page.dart';
import 'package:mentorme/features/consultation/konsultasi.dart';
import 'package:mentorme/features/notifications/notifications.dart';
import 'package:mentorme/core/services/refresh_services.dart';
import 'package:mentorme/features/learning/pelajaranku_page.dart';
import 'package:mentorme/features/project_marketplace/project_marketplace.dart';
import 'package:mentorme/features/home/beranda_page.dart';
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/controller/api_services.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/global/Fontstyle.dart';

class MainScreen extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> learningPaths;

  const MainScreen({
    super.key,
    required this.categories,
    required this.learningPaths,
  });

  @override
  State<MainScreen> createState() => _MainStateScreen();
}

class _MainStateScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  Profile? _profile;
  bool _isLoading = true;
  late final List<Widget> _pages;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initPages();
    _fetchProfile();
  }

  void _initAnimations() {
    // Single controller for minimal animation
    _floatingController = AnimationController(
      duration: const Duration(seconds: 6), // Slower for better performance
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -2.0, // Minimal movement
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  void _initPages() {
    _pages = [
      BerandaPage(
        key: const ValueKey('BerandaPage'),
        categories: widget.categories,
        learningPaths: widget.learningPaths,
        onTabChange: (index, {learningPathId}) => onItemClicked(index),
      ),
      const ProjectPage(key: ValueKey('ProjectPage')),
      const Kegiatanku(key: ValueKey('KegiatankuPage')),
      const KonsultasiPage(key: ValueKey('KonsultasiPage')),
      const ProfilePage(key: ValueKey('ProfileScreen')),
    ];
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    // Tidak perlu setState isLoading di awal jika sudah ada UI loading
    try {
      final profile = await ApiService().fetchProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching profile: $e");
    }
  }

  Future<void> _refreshData() async {
    // Panggil _fetchProfile untuk refresh data
    await _fetchProfile();
  }

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Opsi: Anda bisa panggil _fetchProfile() di sini jika ingin data selalu
    // ter-update setiap pindah tab, tapi pull-to-refresh lebih efisien.
  }

  Widget _buildOptimizedHeader(BuildContext context) {
    if (selectedIndex != 0) return const SizedBox.shrink();

    return Container(
      height: 100.0,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF339989),
            Color(0xFFe0fff3),
            Color(0xFF3c493f),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          _buildMinimalFloatingElements(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildProfileAvatar(),
                  const SizedBox(width: 14),
                  Expanded(child: _buildWelcomeText()),
                  _buildNotificationButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: () => onItemClicked(4),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF339989), Color(0xFF3c493f)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFe0fff3),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF339989),
                  ),
                )
              : ClipOval(
                  child:
                      _profile?.picture != null && _profile!.picture.isNotEmpty
                          ? OptimizedImage(
                              imageUrl: _profile!.picture,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorWidget: Image.asset(
                                'assets/person.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/person.png',
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                            ),
                ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isLoading ? 'Loading...' : 'Hi! ${_profile?.fullName ?? 'User'}',
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: const Color(0xFF3c493f).withOpacity(0.3),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          "Selamat Datang!",
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          enhanced.OptimizedPageRoute(
            child: NotificationPage(),
            transitionType: enhanced.PageTransitionType.slideLeft,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMinimalFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Single floating element for minimal performance impact
            Positioned(
              top: 30 + _floatingAnimation.value,
              right: 80,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildOptimizedHeader(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xff339989),
              // Use IndexedStack for better performance - no rebuild on tab change
              child: IndexedStack(
                index: selectedIndex,
                children: _pages,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFe0fff3).withOpacity(0.3),
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              color: const Color(0xFF339989).withOpacity(0.1),
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              rippleColor: const Color(0xFF339989).withOpacity(0.1),
              hoverColor: const Color(0xFFe0fff3).withOpacity(0.3),
              gap: 6,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              duration: const Duration(milliseconds: 500),
              tabBackgroundGradient: const LinearGradient(
                colors: [Color(0xFF339989), Color(0xFF3c493f)],
              ),
              color: const Color(0xFF3c493f).withOpacity(0.7),
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Beranda',
                ),
                GButton(
                  icon: Icons.layers_outlined,
                  text: 'Project',
                ),
                GButton(
                  icon: Icons.book_outlined,
                  text: 'Kegiatan',
                ),
                GButton(
                  icon: Icons.message_outlined,
                  text: 'Konsultasi',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profil',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                onItemClicked(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

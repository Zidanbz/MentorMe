import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorme/app/constants/app_colors.dart';
import 'package:mentorme/app/constants/app_strings.dart';
import 'package:mentorme/core/storage/storage_service.dart';
import 'package:mentorme/core/error/error_handler.dart';
import 'package:mentorme/features/consultation/help.dart';
import 'package:mentorme/features/notifications/notifications.dart';
import 'package:mentorme/features/auth/login/login_page.dart';
import 'package:mentorme/shared/widgets/custom_button.dart';
import 'package:mentorme/shared/widgets/loading_dialog.dart';
import 'package:mentorme/features/profile/edit_profile.dart';
import 'package:mentorme/features/profile/terms_conditions_page.dart';
import 'package:mentorme/features/profile/privacy_policy_page.dart';
import 'package:mentorme/features/voucher/my_vouchers_page.dart';
import 'package:mentorme/features/voucher/voucher_claim_page.dart';
import 'package:mentorme/features/voucher/voucher_code_claim_page.dart';
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/features/profile/services/profile_api_service.dart';
import 'package:mentorme/models/learning_model.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/app_background.dart';
import 'package:mentorme/global/Fontstyle.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  Profile? _profile;
  List<Learning>? _learningData;
  bool _isLoading = true;
  bool _isLoggingOut = false;
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchProfile();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
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
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() => _isLoading = true);

      // Fetch profile data
      final profileResponse = await ProfileApiService.fetchProfile();
      final learningResponse = await ProfileApiService.fetchUserLearning();

      if (mounted) {
        Profile? profile;
        List<Learning>? learningData;

        // Process profile response
        if (profileResponse.success && profileResponse.data != null) {
          final profileData = profileResponse.data!;
          profile = Profile(
            fullName: profileData['fullName'] ?? '',
            picture: profileData['picture'] ?? '',
            phone: profileData['phone'] ?? '',
          );
        }

        // Process learning response
        if (learningResponse.success && learningResponse.data != null) {
          final learningListData = learningResponse.data!['learning'] ?? [];
          learningData = (learningListData as List)
              .map((item) => Learning.fromJson(item))
              .toList();
        }

        setState(() {
          _profile = profile;
          _learningData = learningData;
          _isLoading = false;
        });

        // Show error if any API call failed
        if (!profileResponse.success) {
          ErrorHandler.showError(
              context, 'Gagal memuat profil: ${profileResponse.message}');
        }
        if (!learningResponse.success) {
          ErrorHandler.showError(context,
              'Gagal memuat data pembelajaran: ${learningResponse.message}');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorHandler.showError(context, error.toString());
      }
    }
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    final shouldLogout = await _showLogoutConfirmation();
    if (!shouldLogout) return;

    setState(() => _isLoggingOut = true);
    LoadingDialog.show(context, message: 'Sedang keluar...');

    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear local storage
      final storage = await SharedPreferencesService.getInstance();
      await storage.clearAll();

      LoadingDialog.hide(context);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          enhanced.OptimizedPageRoute(
            child: const LoginPage(),
            transitionType: enhanced.PageTransitionType.fade,
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      LoadingDialog.hide(context);
      if (mounted) {
        ErrorHandler.showError(context, 'Gagal logout: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFe0fff3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Konfirmasi Logout',
              style: AppTextStyles.headlineSmall.copyWith(
                color: const Color(0xFF3c493f),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Apakah Anda yakin ingin keluar?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF3c493f),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3c493f),
                ),
                child: Text(AppStrings.cancel),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF339989), Color(0xFF3c493f)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(AppStrings.confirm),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: const EditProfileScreen(),
        transitionType: enhanced.PageTransitionType.slideRight,
      ),
    ).then((_) => _fetchProfile()); // Refresh profile after edit
  }

  void _navigateToHelpPage() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: HelpPage(),
        transitionType: enhanced.PageTransitionType.slideUp,
      ),
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: NotificationPage(),
        transitionType: enhanced.PageTransitionType.slideLeft,
      ),
    );
  }

  void _navigateToTermsConditions() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: const TermsConditionsPage(),
        transitionType: enhanced.PageTransitionType.slideUp,
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: const PrivacyPolicyPage(),
        transitionType: enhanced.PageTransitionType.slideUp,
      ),
    );
  }

  void _navigateToMyVouchers() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: const MyVouchersPage(),
        transitionType: enhanced.PageTransitionType.slideRight,
      ),
    );
  }

  void _navigateToClaimVoucher() {
    Navigator.push(
      context,
      enhanced.OptimizedPageRoute(
        child: const VoucherCodeClaimPage(),
        transitionType: enhanced.PageTransitionType.slideLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: _isLoading
            ? _buildLoadingState()
            : enhanced.OptimizedFadeSlide(
                duration: const Duration(milliseconds: 600),
                child: Stack(
                  children: [
                    _buildHeaderActions(),
                    _buildBodyContent(),
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
            // Floating circles
            Positioned(
              top: 100 + _floatingAnimation.value,
              right: 30,
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
              top: 200 - _floatingAnimation.value,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 150 + _floatingAnimation.value,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3c493f).withOpacity(0.1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // DIUBAH: Header disederhanakan, hanya menampilkan judul
  Widget _buildHeaderActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Diubah ke center
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                AppStrings.profile,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIUBAH: Menambahkan _buildAccountActionsSection()
  Widget _buildBodyContent() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80), // Space untuk header
              _buildProfileInfo(),
              const SizedBox(height: 16),
              _buildActionButtons(),
              const SizedBox(height: 20),
              // Tambahkan section voucher
              _buildVoucherSection(),
              const SizedBox(height: 20),
              // Posisi ditukar: Riwayat Transaksi sekarang di atas
              _buildTransactionSection(),
              const SizedBox(height: 20),
              // Posisi ditukar: Informasi Legal sekarang di bawah
              _buildMenuSection(),
              const SizedBox(height: 20),
              _buildAccountActionsSection(),
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // BARU: Method untuk membuat seksi Notifikasi dan Logout
  Widget _buildAccountActionsSection() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF339989), Color(0xFF3c493f)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pengaturan Akun',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: const Color(0xFF3c493f),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              subtitle: 'Lihat pemberitahuan terbaru dari aplikasi',
              onTap: _navigateToNotifications,
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Keluar dari akun Anda saat ini',
              onTap: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return enhanced.OptimizedStaggeredList(
      duration: const Duration(milliseconds: 800),
      staggerDelay: const Duration(milliseconds: 150),
      children: [
        enhanced.OptimizedScale(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF339989), Color(0xFF3c493f)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF339989).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFFe0fff3),
              child: _profile?.picture != null && _profile!.picture.isNotEmpty
                  ? ClipOval(
                      child: OptimizedImage(
                        imageUrl: _profile!.picture,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        placeholder: _buildAvatarShimmer(),
                        errorWidget: _buildAvatarPlaceholder(),
                      ),
                    )
                  : _buildAvatarPlaceholder(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF3c493f), Color(0xFF339989)],
          ).createShader(bounds),
          child: Text(
            _profile?.fullName ?? 'Nama Pengguna',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF339989), Color(0xFF3c493f)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF339989).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            'Mahasiswa',
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF339989).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            'Mahasiswa yang terus belajar dan berkembang',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: const Color(0xFF3c493f),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 400),
      child: Row(
        children: [
          Expanded(
            child: enhanced.OptimizedHover(
              scale: 1.02,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF339989), Color(0xFF3c493f)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF339989).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _navigateToEditProfile,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Edit Profil',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: enhanced.OptimizedHover(
              scale: 1.02,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF339989).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF339989).withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _navigateToHelpPage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.help_outline,
                          color: Color(0xFF339989),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.help,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: const Color(0xFF339989),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherSection() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 450),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF339989), Color(0xFF3c493f)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Voucher',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: const Color(0xFF3c493f),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.wallet_giftcard,
              title: 'Voucher Saya',
              subtitle: 'Lihat semua voucher yang sudah diklaim',
              onTap: _navigateToMyVouchers,
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.redeem,
              title: 'Klaim Voucher',
              subtitle: 'Klaim voucher baru untuk mendapatkan diskon',
              onTap: _navigateToClaimVoucher,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF339989), Color(0xFF3c493f)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Informasi Legal',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: const Color(0xFF3c493f),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: 'Syarat & Ketentuan',
              subtitle: 'Baca syarat dan ketentuan penggunaan aplikasi',
              onTap: _navigateToTermsConditions,
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Kebijakan Privasi',
              subtitle: 'Pelajari bagaimana kami melindungi data Anda',
              onTap: _navigateToPrivacyPolicy,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return enhanced.OptimizedHover(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFe0fff3).withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF339989).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF339989), Color(0xFF3c493f)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF3c493f).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF339989).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF339989),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSection() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF339989), Color(0xFF3c493f)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Riwayat Transaksi',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: const Color(0xFF3c493f),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_learningData == null || _learningData!.isEmpty)
              _buildEmptyState()
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _learningData!.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final learning = _learningData![index];
                  final isSuccess = !learning.progress;
                  return _buildTransactionItem(
                    learning.project.materialName,
                    isSuccess ? 'Berhasil' : 'Gagal',
                    index,
                  );
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: enhanced.OptimizedFadeSlide(
        delay: const Duration(milliseconds: 200),
        child: Column(
          children: [
            const SizedBox(height: 20),
            enhanced.OptimizedScale(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFe0fff3).withOpacity(0.5),
                ),
                child: Image.asset('assets/Maskot.png', width: 120),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada transaksi,\nayo lakukan pembelian!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF3c493f),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String materialName, String status, int index) {
    final isSuccess = status == 'Berhasil';
    return enhanced.OptimizedFadeSlide(
      delay: Duration(milliseconds: 100 * index),
      child: enhanced.OptimizedHover(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFe0fff3).withOpacity(0.3),
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
                  gradient: LinearGradient(
                    colors: isSuccess
                        ? [const Color(0xFF339989), const Color(0xFF3c493f)]
                        : [Colors.red.shade400, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materialName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Transaksi pembelajaran',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF3c493f).withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFF339989).withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSuccess ? const Color(0xFF339989) : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        _buildFloatingElements(),
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const ShimmerCircle(radius: 50),
                  const SizedBox(height: 12),
                  const ShimmerText(width: 180, height: 20),
                  const SizedBox(height: 6),
                  const ShimmerText(width: 80, height: 14),
                  const SizedBox(height: 6),
                  const ShimmerText(width: 250, height: 12),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerCard(
                          width: double.infinity,
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ShimmerCard(
                          width: double.infinity,
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ShimmerText(width: 140, height: 18),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ShimmerCard(
                        width: double.infinity,
                        height: 60,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarShimmer() {
    return const ShimmerCircle(radius: 50);
  }

  Widget _buildAvatarPlaceholder() {
    return const Icon(
      Icons.person,
      size: 60,
      color: Color(0xFF3c493f),
    );
  }
}

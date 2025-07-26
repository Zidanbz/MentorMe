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
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/controller/api_services.dart';
import 'package:mentorme/models/learning_model.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Profile? _profile;
  List<Learning>? _learningData;
  bool _isLoading = true;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      setState(() => _isLoading = true);

      final profile = await ApiService().fetchProfile();
      final learningData = await ApiService().fetchUserLearning();

      if (mounted) {
        setState(() {
          _profile = profile;
          _learningData = learningData;
          _isLoading = false;
        });
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
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  AppStrings.cancel,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  AppStrings.confirm,
                  style: const TextStyle(color: AppColors.error),
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
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    ).then((_) => _fetchProfile()); // Refresh profile after edit
  }

  void _navigateToHelpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpPage()),
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: _isLoading
          ? _buildLoadingState()
          : OptimizedFadeSlide(
              duration: const Duration(milliseconds: 600),
              child: Stack(
                children: [
                  _buildCurvedHeader(),
                  _buildHeaderActions(),
                  _buildBodyContent(),
                ],
              ),
            ),
    );
  }

  Widget _buildCurvedHeader() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 250,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildHeaderActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textLight,
                size: 28,
              ),
              onPressed: _navigateToNotifications,
            ),
            Text(
              AppStrings.profile,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: AppColors.textLight,
                size: 28,
              ),
              onPressed: _isLoggingOut ? null : _handleLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 120), // Space for curved header
            _buildProfileInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 32),
            _buildTransactionSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        CircleAvatar(
          radius: 54,
          backgroundColor: AppColors.primary.withOpacity(0.8),
          child: _profile?.picture != null && _profile!.picture.isNotEmpty
              ? ClipOval(
                  child: OptimizedImage(
                    imageUrl: _profile!.picture,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: _buildAvatarShimmer(),
                    errorWidget: _buildAvatarPlaceholder(),
                  ),
                )
              : _buildAvatarPlaceholder(),
        ),
        const SizedBox(height: 16),
        Text(
          _profile?.fullName ?? 'Nama Pengguna',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mahasiswa',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Saya seorang mahasiswa yang sedang mencari kebenaran',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Edit Profil',
            icon: Icons.edit_outlined,
            onPressed: _navigateToEditProfile,
            type: ButtonType.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomButton(
            text: AppStrings.help,
            icon: Icons.help_outline,
            onPressed: _navigateToHelpPage,
            type: ButtonType.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (_learningData == null || _learningData!.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _learningData!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final learning = _learningData![index];
              final isSuccess = !learning.progress;
              return _buildTransactionItem(
                learning.project.materialName,
                isSuccess ? 'Berhasil' : 'Gagal',
              );
            },
          )
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/Maskot.png', width: 160),
          const SizedBox(height: 16),
          const Text(
            'Belum ada transaksi,\nayo lakukan pembelian!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String materialName, String status) {
    final isSuccess = status == 'Berhasil';
    return OptimizedFadeSlide(
      delay: const Duration(milliseconds: 100),
      child: Card(
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            materialName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Chip(
            label: Text(status),
            labelStyle: TextStyle(
              color: isSuccess ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            backgroundColor: isSuccess
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        _buildCurvedHeader(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 120),
                // Profile Avatar Shimmer
                const ShimmerCircle(radius: 54),
                const SizedBox(height: 16),
                // Name Shimmer
                const ShimmerText(width: 200, height: 24),
                const SizedBox(height: 8),
                // Role Shimmer
                const ShimmerText(width: 100, height: 16),
                const SizedBox(height: 8),
                // Description Shimmer
                const ShimmerText(width: 300, height: 14),
                const SizedBox(height: 24),
                // Buttons Shimmer
                Row(
                  children: [
                    Expanded(
                      child: ShimmerCard(
                        width: double.infinity,
                        height: 48,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShimmerCard(
                        width: double.infinity,
                        height: 48,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Transaction Section Shimmer
                const Align(
                  alignment: Alignment.centerLeft,
                  child: ShimmerText(width: 150, height: 20),
                ),
                const SizedBox(height: 16),
                // Transaction Items Shimmer
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShimmerCard(
                      width: double.infinity,
                      height: 72,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
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
    return CircleAvatar(
      radius: 50,
      backgroundColor: AppColors.background,
      child: const Icon(
        Icons.person,
        size: 60,
        color: AppColors.textHint,
      ),
    );
  }
}

// Custom Clipper for the wave effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

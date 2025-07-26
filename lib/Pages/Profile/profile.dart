import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mentorme/Pages/Konsultasi/help.dart';
import 'package:mentorme/Pages/notifications/notifications.dart';
import 'package:mentorme/features/auth/Login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/controller/api_services.dart';
import 'package:mentorme/models/learning_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- COLOR PALETTE ---
  static const Color primaryColor = Color(0xFF339989);
  static const Color darkTextColor = Color(0xFF3C493F);
  static const Color backgroundColor = Color(0xFFE0FFF3);

  Profile? _profile;
  List<Learning>? _learningData;
  bool _isLoading = true;

  // --- LOGIC (No Changes Needed) ---
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await ApiService().fetchProfile();
      final learningData = await ApiService().fetchUserLearning();
      if (mounted) {
        setState(() {
          _profile = profile;
          _learningData = learningData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching profile or learning data: $e");
    }
  }

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // More efficient way to clear all saved prefs
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
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

  // --- UI WIDGETS (New and Improved) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : Stack(
              children: [
                _buildCurvedHeader(),
                _buildHeaderActions(),
                _buildBodyContent(),
              ],
            ),
    );
  }

  Widget _buildCurvedHeader() {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 250,
        color: primaryColor,
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
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white, size: 28),
              onPressed: _navigateToNotifications,
            ),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              onPressed: () => _handleLogout(context),
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
          backgroundColor: primaryColor.withOpacity(0.8),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage:
                _profile?.picture != null && _profile!.picture.isNotEmpty
                    ? NetworkImage(_profile!.picture)
                    : null,
            child: _profile?.picture == null || _profile!.picture.isEmpty
                ? const Icon(Icons.person, size: 60, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _profile?.fullName ?? 'Nama Pengguna',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Mahasiswa', // This is hardcoded in original code
          style: TextStyle(
              fontSize: 16, color: primaryColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Saya seorang mahasiswa yang sedang mencari kebenaran', // hardcoded
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: darkTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Profil'),
            onPressed: _navigateToEditProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.help_outline, size: 18),
            label: const Text('Bantuan'),
            onPressed: _navigateToHelpPage,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
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
            color: darkTextColor,
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
            style: TextStyle(fontSize: 16, color: darkTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String materialName, String status) {
    final isSuccess = status == 'Berhasil';
    return Card(
      elevation: 2,
      shadowColor: primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: const Icon(Icons.receipt_long_outlined, color: primaryColor),
        ),
        title: Text(
          materialName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: darkTextColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Chip(
          label: Text(status),
          labelStyle: TextStyle(
              color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 12),
          backgroundColor:
              isSuccess ? Colors.green.shade100 : Colors.red.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          visualDensity: VisualDensity.compact,
        ),
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
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

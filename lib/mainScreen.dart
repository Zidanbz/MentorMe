// main_screen.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // <-- BARU: Impor package GNav
import 'package:mentorme/features/profile/profile_page.dart';
import 'package:mentorme/features/consultation/konsultasi.dart';
import 'package:mentorme/features/notifications/notifications.dart';
import 'package:mentorme/core/services/refresh_services.dart';
import 'package:mentorme/features/learning/pelajaranku_page.dart';
import 'package:mentorme/features/project_marketplace/project_marketplace.dart';
import 'package:mentorme/features/home/beranda_page.dart';
import 'package:mentorme/models/Profile_models.dart';
import 'package:mentorme/controller/api_services.dart';

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

class _MainStateScreen extends State<MainScreen> {
  int selectedIndex = 0;
  Profile? _profile;
  bool _isLoading = true;
  late final List<Widget> _pages; // <-- BARU: List untuk menampung halaman

  @override
  void initState() {
    super.initState();
    _pages = [
      BerandaPage(
        key: const ValueKey(
            'BerandaPage'), // <-- BARU: Key untuk AnimatedSwitcher
        categories: widget.categories,
        learningPaths: widget.learningPaths,
        onTabChange: (index, {learningPathId}) => onItemClicked(index),
      ),
      const ProjectPage(key: ValueKey('ProjectPage')),
      const Kegiatanku(key: ValueKey('KegiatankuPage')),
      const KonsultasiPage(key: ValueKey('KonsultasiPage')),
      const ProfilePage(key: ValueKey('ProfileScreen')),
    ];
    _fetchProfile(); // Initial fetch
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

  // DIUBAH: Header diekstrak menjadi method sendiri untuk kerapian
  Widget _buildAnimatedHeader(BuildContext context) {
    // BARU: Menggunakan AnimatedContainer untuk animasi hide/show
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: selectedIndex == 0 ? 90.0 : 0, // <-- Kunci animasi
      color: const Color(0xffE0FFF3),
      child: SingleChildScrollView(
        // Mencegah overflow saat animasi
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            // bottom: 16,
          ),
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onItemClicked(4),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: _isLoading
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : ClipOval(
                                child: _profile?.picture != null &&
                                        _profile!.picture.isNotEmpty
                                    ? Image.network(
                                        _profile!.picture,
                                        fit: BoxFit.cover,
                                        width: 48,
                                        height: 48,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset('assets/person.png',
                                                    width: 48, height: 48),
                                      )
                                    : Image.asset('assets/person.png',
                                        width: 48, height: 48),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoading
                              ? 'Loading...'
                              : 'Hi! ${_profile?.fullName ?? 'User'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 28),
                  color: const Color(0xff339989),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAnimatedHeader(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xff339989),
              // DIUBAH: Menggunakan AnimatedSwitcher untuk transisi halaman yang halus
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _pages[selectedIndex],
              ),
            ),
          ),
        ],
      ),
      // DIUBAH: Menggunakan GNav untuk bottom navigation yang lebih modern
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 5, // <-- DIUBAH: Kurangi spasi
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12), // <-- DIUBAH: Kurangi padding horizontal
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color(0xff339989),
              color: Colors.black54,
              tabs: const [
                GButton(icon: Icons.home_outlined, text: 'Beranda'),
                GButton(icon: Icons.layers_outlined, text: 'Project'),
                GButton(icon: Icons.book_outlined, text: 'Kegiatan'),
                GButton(icon: Icons.message_outlined, text: 'Konsultasi'),
                GButton(icon: Icons.person_outline, text: 'Profil'),
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

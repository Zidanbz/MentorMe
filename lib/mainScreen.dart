import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Profile/profile.dart';
import 'package:mentorme/Pages/Konsultasi/konsultasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentorme/Pages/notifications/notifications.dart';
import 'package:mentorme/core/services/refresh_services.dart';
import 'package:mentorme/features/Pelajaranku/pelajaranku_page.dart';
import 'package:mentorme/features/Project_Marketplace/project_marketplace.dart';
import 'package:mentorme/features/beranda/beranda_page.dart';
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

class _MainStateScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;
  String userName = '';
  String selectedLearningPathId = '';
  Profile? _profile;
  bool _isLoading = true;
  // int _coinBalance = 0;
  // bool _isCoinLoading = true;

  void handleTabChange(int index, {String? learningPathId}) {
    if (tabController != null) {
      setState(() {
        selectedIndex = index;
        tabController!.index = selectedIndex;
        if (learningPathId != null) {
          selectedLearningPathId = learningPathId;
        }
      });
    }
  }
  

  Future<void> _fetchProfile() async {
    try {
      final profile = await ApiService().fetchProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error in fetching profile
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching profile: $e");
    }
  }

  Future<void> _refreshData() async {
    final profile = await RefreshService.refreshProfile();
    if (profile != null && mounted) {
      setState(() {
        _profile = profile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    _fetchProfile();
    // _fetchCoinBalance();
  }

  Future<void> getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data()?['fullName'] ?? 'User';
          });
        } else {
          print('Data pengguna tidak ditemukan');
        }
      }
    } catch (e) {
      print('Error mengambil nama pengguna: $e');
    }
  }

  void onItemClicked(int index) {
    if (tabController != null) {
      setState(() {
        selectedIndex = index;
        tabController!.index = selectedIndex;
      });
    }
  }

  Widget _buildNavigationBarItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: isSelected ? const EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xffE0FFF3),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      padding: const EdgeInsets.all(4),
      child: Icon(
        icon,
        size: isSelected ? 30 : 24, // Ikon lebih besar jika dipilih
        color: isSelected ? const Color(0xff339989) : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header yang hanya muncul jika bukan di Profile page
          if (selectedIndex != 4)
            Container(
              color: const Color(0xffE0FFF3),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onItemClicked(4);
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: (_profile?.picture != null)
                                ? Image.network(
                                    _profile!.picture,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/person.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ).image
                                : const AssetImage('assets/person.png'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi! ${_profile?.fullName ?? 'User'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications),
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
                  ],
                ),
              ),
            ),
          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  BerandaPage(
                    categories: widget.categories,
                    learningPaths: widget.learningPaths,
                    onTabChange: handleTabChange,
                  ),
                  const ProjectPage(),
                  const Kegiatanku(),
                  KonsultasiPage(),
                  const ProfileScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: _buildNavigationBarItem(Icons.home, 'Beranda', 0),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon:
                _buildNavigationBarItem(Icons.layers, 'Project Marketplace', 1),
            label: 'Project Marketplace',
          ),
          BottomNavigationBarItem(
            icon: _buildNavigationBarItem(Icons.book, 'Pelajaranku', 2),
            label: 'Pelajaranku',
          ),
          BottomNavigationBarItem(
            icon: _buildNavigationBarItem(Icons.message, 'Konsultasi', 3),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: _buildNavigationBarItem(Icons.person, 'Profil', 4),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
        selectedItemColor: const Color(0xff339989),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

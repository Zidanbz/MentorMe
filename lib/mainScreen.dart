import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Kegiatanku/kegiatanku.dart';
import 'package:mentorme/Pages/Profile/profile.dart';
import 'package:mentorme/Pages/Projectku/project_marketplace.dart';
import 'package:mentorme/Pages/Konsultasi/konsultasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Definisikan handleTabChange
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    getUserName();
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
            userName = userDoc.data()?['nama'] ?? 'User';
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
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage('assets/person.png'),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi! $userName',
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
                          onPressed: () {},
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xff7DE2D1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/Coin.png',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '15',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.add_box,
                                  color: Color(0xff339989),
                                  size: 24,
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
          // Content
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                BerandaPage(
                  categories: widget.categories,
                  learningPaths: widget.learningPaths,
                  onTabChange: handleTabChange, // Gunakan handleTabChange
                ),
                const ProjectPage(),
                const Pelajaranku(),
                KonsultasiPage(),
                const ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'ProjectKu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Pelajaranku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Konsultasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        type: BottomNavigationBarType.fixed,
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

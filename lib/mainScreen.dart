import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Kegiatanku/kegiatanku.dart';
import 'package:mentorme/Pages/Projectku/project_marketplace.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainStateScreen();
}

class _MainStateScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    if (tabController != null) {
      // <-- Tambahkan pengecekan null
      setState(() {
        selectedIndex = index;
        tabController!.index = selectedIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffE0FFF3),
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/User.jpg'),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi! Zidan',
                      style: TextStyle(
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
                    // Handle notifications icon tap
                  },
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
                        onTap: () {
                          // Handle the add button tap
                        },
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
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          BerandaPage(),
          ProjectPage(),
          Pelajaranku(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Pelajaranku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}

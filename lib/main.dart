import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Kegiatanku/kegiatanku.dart';
import 'package:mentorme/Pages/Login/login_page.dart';
import 'package:mentorme/Pages/Projectku/project_marketplace.dart';
import 'package:mentorme/splash_screen.dart';
import 'package:mentorme/PagesForMentor/Daftar/DaftarForMentorThree.dart';
import 'package:mentorme/PagesForMentor/projectForMentor/projectForMentor.dart';
import 'package:mentorme/PagesForMentor/projectForMentor/uploadProject.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum Role { trainee, mentor }

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  Role _userRole = Role.trainee; // Inisialisasi peran

  final List<Widget> _pagesTrainee = [
    const SplashScreen(),
    const BerandaPage(),
    const ProjectPage(),
    const Pelajaranku(),
    // ... halaman lainnya untuk trainee
  ];

  final List<Widget> _pagesMentor = [
    TambahProjectPage(),
    ProjectForMentorPage(),
    // ... halaman lainnya untuk mentor
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SFPro',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      home: Scaffold(
        appBar: _userRole == Role.trainee ? appBarTrainee() : appBarMentor(),
        body: _userRole == Role.trainee
            ? _pagesTrainee[_currentIndex]
            : _pagesMentor[_currentIndex],
        bottomNavigationBar: _userRole == Role.trainee
            ? navbarTrainee(_currentIndex, (index) {
                setState(() {
                  _currentIndex = index;
                });
              })
            : navbarMentor(_currentIndex, (index) {
                setState(() {
                  _currentIndex = index;
                });
              }),
      ),
    );
  }
}

AppBar appBarTrainee() {
  return AppBar(
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
  );
}

AppBar appBarMentor() {
  // Implementasi AppBar untuk mentor (bisa sama dengan appBarTrainee atau berbeda)
  return AppBar(
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
                  'Hi! Mahmud',
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
  );
}

BottomNavigationBar navbarTrainee(int currentIndex, Function(int) onTap) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    currentIndex: currentIndex,
    onTap: onTap,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    items: const [
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
  );
}

BottomNavigationBar navbarMentor(int currentIndex, Function(int) onTap) {
  // Implementasi Navbar untuk mentor (bisa sama dengan navbarTrainee atau berbeda)
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    currentIndex: currentIndex,
    onTap: onTap,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.layers),
        label: 'Project',
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
  );
}

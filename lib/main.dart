import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Kegiatanku/kegiatanku.dart';
import 'package:mentorme/Pages/Login/login_page.dart';
import 'package:mentorme/Pages/Projectku/project_marketplace.dart';
import 'package:mentorme/Pages/SplashScreen/splash_screen.dart';
import 'package:mentorme/PagesForMentor/Daftar/DaftarForMentorThree.dart';
import 'package:mentorme/PagesForMentor/uploadProject/uploadProject.dart';
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

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TambahProjectPage(),
    // const UploadFotoPage(),
    const SplashScreen(),
    const LoginPage(),
    const BerandaPage(),
    const ProjectPage(),
    const Pelajaranku(),

    // HomeScreen(),
    // Tambahkan halaman lain di sini jika ada
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SFPro',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xffE0FFF3),
        appBar: _currentIndex == 0 || _currentIndex == 1
            ? null
            : AppBar(
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
        body: _pages[_currentIndex],
        bottomNavigationBar: _currentIndex == 0
            ? null
            : Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.white,
                    currentIndex: _currentIndex,
                    onTap: (int newIndex) {
                      setState(() {
                        _currentIndex = newIndex;
                      });
                    },
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
                  ),
                ),
              ),
      ),
    );
  }
}

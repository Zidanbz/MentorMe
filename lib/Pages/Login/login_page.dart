import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Beranda/beranda.dart';
import 'package:mentorme/Pages/Daftar/daftar_page.dart';
import 'package:mentorme/dft.dart';
import 'package:mentorme/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFF3),
      body: SingleChildScrollView(
        // Agar keyboard tidak menutupi input
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png', // Ganti dengan path logo
                width: 200,
                height: 200,
              ),
              const Text(
                'MentorMe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Masukkan email dan password Anda',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true, // Menyembunyikan password
                decoration: InputDecoration(
                  hintText: 'Kata Sandi',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Or social login',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     // Aksi login dengan Apple
                  //   },
                  //   icon: const Icon(Icons.apple),
                  //   iconSize: 40,
                  // ),
                  // const SizedBox(width: 15),
                  IconButton(
                    onPressed: () {
                      // Aksi login dengan Google
                    },
                    icon: Image.asset(
                      'assets/google.png',
                      width: 27, // Lebar gambar
                      height: 27,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  // Aksi login
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BerandaPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffffffff),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF339989),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      // Aksi navigasi ke halaman daftar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Daftar disini',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF339989),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  // Aksi untuk tombol fingerprint
                },
                icon: const Icon(Icons.fingerprint),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

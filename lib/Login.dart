import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/Logo.png', width: 200, height: 200),
            const SizedBox(height: 10), // Adjust spacing as needed
            Text(
              'Masuk',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Masukkan E-Mail dan Password Anda',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30), // Adjust spacing as needed
            Container(
              width: 300,
              height: 60,
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'E-Mail',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Adjust opacity here
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Add some space between the text fields
            Container(
              width: 300,
              height: 60,
              child: TextField(
                obscureText: true, // To obscure the password
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5), // Adjust opacity here
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Add some space between the text fields
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
              },
              child: Text(
                'Masuk',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff339989)),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.white,
                minimumSize: Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
            const SizedBox(height: 20), // Adjust spacing as needed
            Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 30,
                    endIndent: 10,
                  ),
                ),
                Text(
                  "or social media",
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 5,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Adjust spacing as needed
            Container(
              width: 300,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your Google sign-in logic here
                    },
                    icon:
                        Image.asset('assets/google.png', width: 24, height: 24),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Add space between buttons
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your Apple sign-in logic here
                    },
                    icon: Icon(Icons.apple, size: 24),
                    label: Text('Sign in with Apple'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

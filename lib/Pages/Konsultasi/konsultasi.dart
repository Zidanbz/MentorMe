import 'package:flutter/material.dart';

class KonsultasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7EF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 25),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              'Konsultasi',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/notificationlogo.png',
                    width: 24,
                    height: 24,
                    color: Colors.teal,
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  // Add coin button action here
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/coin_icon.png',
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '15',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' +',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Konsultasi Banner Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: InkWell(
              onTap: () {
                // Add consultation action here
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Color(0xff27DEBF), // Updated to match the image
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: Image.asset(
                            'assets/leaves.png',
                            height: 30,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(-1.0, 1.0, 1.0),
                            child: Image.asset(
                              'assets/leaves.png',
                              height: 30,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      15), // Sesuaikan nilai bottom sesuai kebutuhan
                              child: Text(
                                'Konsultasi disini!',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -25, // Adjusted to make circle smaller
                    child: Container(
                      padding: EdgeInsets.all(
                          20), // Adjusted padding for smaller circle
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/coin_icon.png',
                            width: 18, // Smaller coin icon
                            height: 18,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Smaller text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 35),

          Center(
            child: Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 15),

          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                InkWell(
                  onTap: () {
                    // Add action for Natifa's history
                  },
                  child: ConsultationHistoryItem(
                    name: 'Natifa Putri',
                    role: 'Mentor',
                    status: 'Riwayat chat: Sesi Konsultasi Selesai',
                    imagePath: 'assets/natifa.png',
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // Add action for Allan's history
                  },
                  child: ConsultationHistoryItem(
                    name: 'Allan Dev',
                    role: 'Mentor',
                    status: 'Riwayat chat: Sesi Konsultasi Selesai',
                    imagePath: 'assets/allan.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultationHistoryItem extends StatelessWidget {
  final String name;
  final String role;
  final String status;
  final String imagePath;

  ConsultationHistoryItem({
    required this.name,
    required this.role,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF63C4A5).withOpacity(0.2), // Updated to match the image
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 25,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

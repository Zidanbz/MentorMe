import 'package:flutter/material.dart';

class DetailKegiatan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE0FFF3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detail Kegiatan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xff3DD598).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/mentor.png'),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pemrograman Web',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text('Nama Mentor: Mulyono'),
                      SizedBox(height: 4.0),
                      Text('Total Progress: 0%'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView(
                children: [
                  buildActivityCard(
                      'Pertemuan 1', 'Belajar dasar HTML, CSS, Javascript'),
                  buildActivityCard('Pertemuan 2',
                      'Menerapkan Program HTML, CSS, Javascript'),
                  buildActivityCard('Pertemuan 3', 'Website Pertama'),
                  buildActivityCard(
                      'Pertemuan 4', 'Tugas Akhir membuat Website'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActivityCard(String title, String description) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.red,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'Belum dibuat',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(description),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3DD598),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Isi Project'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

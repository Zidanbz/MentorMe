import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<AppNotification> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/notif/all'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 200 && data['data'] != null) {
          setState(() {
            notifications = (data['data'] as List)
                .map((notification) => AppNotification.fromJson(notification))
                .toList();
            isLoading = false;
          });
        } else {
          print('API Error: ${data['message']}');
          setState(() => isLoading = false);
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Fetch Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff80CBC4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifikasi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('Tidak ada notifikasi'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                          notification: notifications[index]);
                    },
                  ),
                ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar di kiri
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Maskot.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16), // Jarak antara gambar dan teks

            // Bagian teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    // child: ElevatedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.teal,
                    //     foregroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8.0),
                    //     ),
                    //   ),
                    //   child: Text('Lihat Detail'),
                    // ),
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

// Model Notifikasi
class AppNotification {
  final String id;
  final String title;
  final String message;

  AppNotification(
      {required this.id, required this.title, required this.message});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['ID'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      message: json['message'] ?? 'Tidak ada pesan',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

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
                .toList()
              ..sort((a, b) =>
                  b.createdAt.compareTo(a.createdAt)); // Urutkan dari terbaru
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
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada notifikasi',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchNotifications,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationCard(
                            notification: notifications[index]);
                      },
                    ),
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
    // Format the date
    String formattedDate =
        DateFormat('dd MMM yyyy, HH:mm').format(notification.createdAt);

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/Maskot.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
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
                  // Display the formatted date
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (notification.actionText != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Aksi ketika tombol diklik
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff339989),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(notification.actionText!),
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

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? actionText;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.actionText,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;

    if (json['timestamp'] is String) {
      parsedDate = DateTime.parse(json['timestamp']);
    } else if (json['timestamp'] != null &&
        json['timestamp']['_seconds'] != null) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(
          json['timestamp']['_seconds'] * 1000);
    } else {
      parsedDate = DateTime.now();
    }

    return AppNotification(
      id: json['ID']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Tanpa Judul',
      message: json['message']?.toString() ?? 'Tidak ada pesan',
      createdAt: parsedDate,
      actionText: json['actionText']?.toString(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mentorme/models/notif_model.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<AppNotification> notifications =
      []; // Changed from Notification to AppNotification
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await http
        .get(Uri.parse('https://widgets-catb7yz54a-uc.a.run.app/api/get/all'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        setState(() {
          notifications = (data['error'] as List)
              .map((notification) => AppNotification.fromJson(
                  notification)) // Changed from Notification to AppNotification
              .toList();
          isLoading = false;
        });
      } else {
        // Handle API error
        setState(() {
          isLoading = false;
        });
        print('API Error: ${data['message']}');
      }
    } else {
      // Handle HTTP error
      setState(() {
        isLoading = false;
      });
      print('HTTP Error: ${response.statusCode}');
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notification: notifications[index]);
                },
              ),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification
      notification; // Changed from Notification to AppNotification

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
            Text(
              notification.message,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

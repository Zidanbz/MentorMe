import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/Pages/Konsultasi/roomchat.dart';
import 'package:mentorme/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KonsultasiPage extends StatefulWidget {
  @override
  _KonsultasiPageState createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  List<dynamic> chatRooms = [];
  bool isLoading = true;

  String get currentUserName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '-';
  String get currentUserEmail =>
      FirebaseAuth.instance.currentUser?.email ?? '-';
  String get currentUserRole => 'customer'; // atau bisa kamu ubah sesuai login

  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    final url = Uri.parse(
      'https://widgets-catb7yz54a-uc.a.run.app/api/chat',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );
      final body = json.decode(response.body);
      print(body);
      if (response.statusCode == 200 && body['data'] != null) {
        setState(() {
          chatRooms = body['data'];
          isLoading = false;
        });
      } else {
        print('Error: ${body['error']}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching chat: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'KONSULTASI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        final room = chatRooms[index];

                        final isCurrentUserCustomer =
                            room['nameCustomer'] == currentUserName;
                        final myName = isCurrentUserCustomer
                            ? room['nameMentor']
                            : room['nameCustomer'];
                        final myRole =
                            isCurrentUserCustomer ? 'customer' : 'mentor';
                        final otherUserName = isCurrentUserCustomer
                            ? room['nameCustomer']
                            : room['nameMentor'];
                        final otherUserRole = isCurrentUserCustomer
                            ? 'Customer'
                            : 'Mentor'; // ✅ Tambahan

                        return Column(
                          children: [
                            _buildHistoryItem(
                              context,
                              otherUserName,
                              otherUserRole, // ✅ Gunakan ini
                              'Riwayat chat',
                              'assets/default.png',
                              room['idRoom'],
                              myName,
                              currentUserEmail,
                              myRole,
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String name,
    String role,
    String status,
    String imagePath,
    int idRoom,
    String currentUserName,
    String currentUserEmail,
    String currentUserRole,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomchatPage(
              roomId: idRoom,
              currentUserName: currentUserName,
              currentUserEmail: currentUserEmail,
              currentUserRole: currentUserRole,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF27DEBF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    role,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
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

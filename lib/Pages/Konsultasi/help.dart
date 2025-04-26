import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentorme/global/global.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  String? localDisplayName;
  String? localEmail;
  int? roomId;

  @override
  void initState() {
    super.initState();
    _loadLocalUserData().then((_) {
      _initChat();
    });
  }

  Future<void> _loadLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    localDisplayName = prefs.getString('nameUser');
    localEmail = prefs.getString('emailUser');
    print('👤 Display name (local): $localDisplayName');
  }

  Future<void> _initChat() async {
    roomId = await _getOrCreateChatRoom();
    setState(() {});
  }

  Future<int?> _getOrCreateChatRoom() async {
    final email = localEmail;
    final displayName = localDisplayName;
    final emailAdmin = 'adminn@gmail.com';

    if (email == null || displayName == null) {
      print('❌ Email atau displayName pengguna tidak ditemukan');
      return null;
    }

    try {
      print('🔍 Cek riwayat chat...');
      final response = await http.get(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat'),
        headers: {'Authorization': 'Bearer $currentUserToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final chatRooms = data['data'] as List;

        final existingRoom = chatRooms.firstWhere(
          (room) =>
              room['nameCustomer'] == displayName &&
              room['nameMentor'].toString().toLowerCase() == 'admin',
          orElse: () => null,
        );

        if (existingRoom != null) {
          print('📌 Room ditemukan: ${existingRoom['idRoom']}');
          return existingRoom['idRoom'];
        }
      }

      print('🆕 Membuat room baru ke admin...');
      final postResponse = await http.post(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentUserToken',
        },
        body: jsonEncode({'email': emailAdmin}),
      );

      if (postResponse.statusCode == 200) {
        final result = jsonDecode(postResponse.body);
        print('✅ Room baru dibuat: ${result['data']}');
        return result['data'];
      }
    } catch (e) {
      print('❌ Error saat ambil/membuat room: $e');
    }

    print('❌ Gagal mendapatkan atau membuat room');
    return null;
  }

  void _sendMessage() {
    if (localDisplayName == null || localEmail == null || roomId == null) {
      print('❗ Display name, email, atau room belum siap');
      return;
    }

    if (_messageController.text.isNotEmpty) {
      _firestore.collection('messages').add({
        'roomId': roomId, // 👈 Ini yang dipakai untuk filter
        'text': _messageController.text,
        'sender': localDisplayName,
        'senderEmail': localEmail,
        'senderRole': 'CUSTOMER',
        'timestamp': FieldValue.serverTimestamp(),
      }).then((doc) {
        print('✅ Pesan dikirim ke messages/${doc.id}');
      }).catchError((e) {
        print('❌ Gagal kirim pesan: $e');
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE0FFF3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chat Bantuan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffE0FFF3),
      body: roomId == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('messages')
                        .where('roomId', isEqualTo: roomId)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          final isSender =
                              message['sender'] == localDisplayName;

                          return ChatBubble(
                            isSender: isSender,
                            message: message['text'],
                            senderName: message['sender'],
                            avatarUrl: 'assets/trainee_avatar.png',
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Ketik pesan...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.teal),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String senderName;
  final String avatarUrl;

  ChatBubble({
    required this.isSender,
    required this.message,
    required this.senderName,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isSender)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              senderName,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        Row(
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender) ...[
              CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
              SizedBox(width: 10),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSender ? Colors.teal : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSender ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            if (isSender) ...[
              SizedBox(width: 10),
              CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
            ],
          ],
        ),
      ],
    );
  }
}

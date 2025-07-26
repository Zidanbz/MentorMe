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
  // Variabel untuk menyimpan data room lengkap, termasuk URL gambar
  Map<String, dynamic>? _chatRoomData;

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
  }

  Future<void> _initChat() async {
    // Panggil _getOrCreateChatRoom dan simpan hasilnya
    final roomData = await _getOrCreateChatRoom();
    if (mounted && roomData != null) {
      setState(() {
        _chatRoomData = roomData;
        roomId = roomData['idRoom']; // Ambil idRoom dari data yang disimpan
      });
    }
  }

  // Mengubah fungsi untuk mengembalikan Map, bukan hanya ID
  Future<Map<String, dynamic>?> _getOrCreateChatRoom() async {
    final email = localEmail;
    final displayName = localDisplayName;
    final emailAdmin = 'adminn@gmail.com';

    if (email == null || displayName == null) {
      return null;
    }
    try {
      // 1. Cek apakah room sudah ada
      var response = await http.get(
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
          return existingRoom; // Kembalikan data room yang sudah ada
        }
      }

      // 2. Jika tidak ada, buat room baru
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
        final newRoomId = result['data'];

        // 3. Ambil lagi data chat untuk mendapatkan detail room yang baru dibuat
        response = await http.get(
          Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat'),
          headers: {'Authorization': 'Bearer $currentUserToken'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final chatRooms = data['data'] as List;
          final newRoomData = chatRooms.firstWhere(
              (room) => room['idRoom'] == newRoomId,
              orElse: () => null);
          if (newRoomData != null) return newRoomData;
        }
      }
    } catch (e) {
      print('❌ Error saat ambil/membuat room: $e');
    }
    return null;
  }

  void _sendMessage() {
    if (localDisplayName == null || localEmail == null || roomId == null)
      return;

    if (_messageController.text.isNotEmpty) {
      _firestore.collection('messages').add({
        'roomId': roomId,
        'text': _messageController.text,
        'sender': localDisplayName,
        'senderEmail': localEmail,
        'senderRole': 'CUSTOMER',
        'timestamp': FieldValue.serverTimestamp(),
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
                        final isSender = message['senderEmail'] == localEmail;

                        String? avatarUrl;
                        if (isSender) {
                          // Jika pengirim adalah user, gunakan URL dari data room
                          avatarUrl = _chatRoomData?['pictureCustomer'];
                        } else {
                          // Jika pengirim adalah admin, gunakan aset lokal
                          avatarUrl = 'assets/Maskot.png';
                        }
                        return ChatBubble(
                          isSender: isSender,
                          message: message['text'],
                          senderName: message['sender'],
                          avatarUrl: avatarUrl,
                        );
                      },
                    );
                  },
                )),
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
  final String? avatarUrl;

  ChatBubble({
    required this.isSender,
    required this.message,
    required this.senderName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Logika untuk memilih ImageProvider berdasarkan sumber gambar
    ImageProvider imageProvider;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('http')) {
        // Jika URL dari internet
        imageProvider = NetworkImage(avatarUrl!);
      } else {
        // Jika path dari aset lokal
        imageProvider = AssetImage(avatarUrl!);
      }
    } else {
      // Gambar fallback jika tidak ada URL atau path
      imageProvider = AssetImage('assets/trainee_avatar.png');
    }

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isSender)
          Padding(
            padding: const EdgeInsets.only(left: 65, top: 4),
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
              CircleAvatar(backgroundImage: imageProvider),
              SizedBox(width: 10),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSender ? Colors.teal : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
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
            if (isSender) SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}

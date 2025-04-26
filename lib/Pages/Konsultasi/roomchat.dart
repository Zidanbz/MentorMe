import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/global/global.dart'; // pastikan kamu punya token di sini

class RoomchatPage extends StatefulWidget {
  final int roomId;
  final String currentUserName;
  final String currentUserEmail;
  // final String currentUserRole; // 'MENTOR' atau 'USER'

  RoomchatPage({
    required this.roomId,
    required this.currentUserName,
    required this.currentUserEmail,
    // required this.currentUserRole,
  });

  @override
  _RoomchatPageState createState() => _RoomchatPageState();
}

class _RoomchatPageState extends State<RoomchatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Tambahkan ScrollController
  Map<String, dynamic>? roomData;
  bool isLoadingRoom = true;

  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  Future<void> fetchRoomData() async {
    final url = Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'];

        final matchedRoom = data.firstWhere(
          (room) => room['idRoom'] == widget.roomId,
          orElse: () => null,
        );

        if (matchedRoom != null) {
          setState(() {
            roomData = matchedRoom;
            isLoadingRoom = false;
          });
        } else {
          print('Room not found');
          setState(() => isLoadingRoom = false);
        }
      } else {
        print('Failed to fetch room: ${response.body}');
        setState(() => isLoadingRoom = false);
      }
    } catch (e) {
      print('Error fetching room data: $e');
      setState(() => isLoadingRoom = false);
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'roomId': widget.roomId,
      'sender': widget.currentUserName,
      'senderEmail': widget.currentUserEmail,
      // 'senderRole': widget.currentUserRole.toUpperCase(),
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
    // Scroll ke bawah setelah mengirim pesan
    _scrollToBottom();
  }

  // Fungsi untuk scroll otomatis ke bawah
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
        title: Text(
          isLoadingRoom
              ? 'Room Chat'
              : 'Chat with ${roomData?['nameMentor'] ?? 'Mentor'}',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffE0FFF3),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Pesan anda terenkripsi secara end-to-end.\nHarap mengikuti panduan dan etika dalam mengirim pesan',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('roomId', isEqualTo: widget.roomId)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                // Scroll otomatis ke bawah setelah data berhasil dimuat
                if (docs.isNotEmpty) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    _scrollToBottom();
                  });
                }

                return ListView.builder(
                  controller: _scrollController, // Set controller di ListView
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final isSender = data['sender'] == widget.currentUserName;

                    return ChatBubble(
                      isSender: isSender,
                      message: data['text'] ?? '',
                      time: (data['timestamp'] as Timestamp?)
                              ?.toDate()
                              .toLocal()
                              .toString()
                              .substring(11, 16) ??
                          '',
                      avatarUrl:
                          isSender ? 'assets/person.png' : 'assets/person.png',
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
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey[700]),
                  onPressed: () {},
                ),
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
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Color(0xff80CBC4),
                    child: Icon(Icons.send, color: Colors.white),
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

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;
  final String time;
  final String avatarUrl;

  ChatBubble({
    required this.isSender,
    required this.message,
    required this.time,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender) CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
        if (!isSender) SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSender ? Color(0xff80CBC4) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isSender ? Radius.circular(12) : Radius.circular(0),
                bottomRight:
                    isSender ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        if (isSender) SizedBox(width: 10),
        if (isSender) CircleAvatar(backgroundImage: AssetImage(avatarUrl)),
      ],
    );
  }
}

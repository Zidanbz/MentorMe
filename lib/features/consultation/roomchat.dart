import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/features/consultation/services/consultation_api_service.dart';
import 'package:mentorme/global/global.dart';

class RoomchatPage extends StatefulWidget {
  // PERBAIKAN: Menghapus spasi pada nama variabel
  final int roomId;
  final String currentUserName;
  final String currentUserEmail;

  RoomchatPage({
    required this.roomId,
    required this.currentUserName,
    required this.currentUserEmail,
  });

  @override
  _RoomchatPageState createState() => _RoomchatPageState();
}

class _RoomchatPageState extends State<RoomchatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? roomData;
  bool isLoadingRoom = true;

  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  // PERBAIKAN: Menghapus spasi pada nama getter
  String get otherUserName {
    if (roomData == null) return '...';
    // PERBAIKAN: Menggunakan nama variabel yang benar
    if (widget.currentUserName == roomData!['nameMentor']) {
      return roomData!['nameCustomer'] ?? 'Customer';
    }
    return roomData!['nameMentor'] ?? 'Mentor';
  }

  Future<void> fetchRoomData() async {
    try {
      final response = await ConsultationApiService.fetchChatRooms();

      if (mounted) {
        if (response.success && response.data != null) {
          final List<dynamic> data = response.data!;
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
            setState(() => isLoadingRoom = false);
          }
        } else {
          setState(() => isLoadingRoom = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoadingRoom = false);
      }
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Menambahkan pesan ke Firestore
    await FirebaseFirestore.instance.collection('messages').add({
      'roomId': widget.roomId,
      'sender': widget.currentUserName,
      'senderEmail': widget.currentUserEmail,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mengupdate lastSender di API backend menggunakan ConsultationApiService
    try {
      await ConsultationApiService.updateLastSender(
        roomId: widget.roomId,
        lastSender: widget.currentUserEmail,
      );
    } catch (e) {
      print("Failed to update last sender: $e");
    }

    _messageController.clear();
    _scrollToBottom();
  }

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
          // PERBAIKAN: Menggunakan nama getter yang benar
          isLoadingRoom ? 'Room Chat' : 'Chat with $otherUserName',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Belum ada pesan'));
                }

                final docs = snapshot.data!.docs;

                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    // PERBAIKAN: Menggunakan nama variabel yang benar
                    final isSender =
                        data['senderEmail'] == widget.currentUserEmail;

                    String? avatarUrl;
                    if (roomData != null) {
                      if (data['senderEmail'] == roomData!['emailMentor']) {
                        avatarUrl = roomData!['pictureMentor'];
                      } else {
                        avatarUrl = roomData!['pictureCustomer'];
                      }
                    }

                    return ChatBubble(
                      isSender: isSender,
                      message: data['text'] ?? '',
                      time: (data['timestamp'] as Timestamp?)
                              ?.toDate()
                              .toLocal()
                              .toString()
                              .substring(11, 16) ??
                          '',
                      avatarUrl: avatarUrl,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      prefixIcon: Icon(Icons.message, color: Colors.grey),
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
  final String? avatarUrl;

  ChatBubble({
    required this.isSender,
    required this.message,
    required this.time,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object> imageProvider =
        (avatarUrl != null && avatarUrl!.isNotEmpty)
            ? NetworkImage(avatarUrl!)
            : AssetImage('assets/person.png') as ImageProvider;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: Colors.grey[200],
              radius: 20,
            ),
          if (!isSender) SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSender ? Color(0xff80CBC4) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft:
                      isSender ? Radius.circular(15) : Radius.circular(0),
                  bottomRight:
                      isSender ? Radius.circular(0) : Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSender ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) SizedBox(width: 10),
          if (isSender)
            CircleAvatar(
              backgroundImage: imageProvider,
              backgroundColor: Colors.grey[200],
              radius: 20,
            ),
        ],
      ),
    );
  }
}

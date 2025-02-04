import 'package:flutter/material.dart';

class RoomchatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE0FFF3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Zidan',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              'Hari ini',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
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
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                ChatBubble(
                  isSender: true,
                  message: 'Halo, Sulaiman ada yang bisa saya bantu?',
                  time: '09:41',
                  avatarUrl: 'assets/mentor_avatar.png',
                ),
                SizedBox(height: 8),
                ChatBubble(
                  isSender: false,
                  message: 'Saya sedang kebingungan mengenai sesuatu...',
                  time: '09:41',
                  avatarUrl: 'assets/trainee_avatar.png',
                ),
              ],
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
                CircleAvatar(
                  backgroundColor: Color(0xff80CBC4),
                  child: Icon(Icons.send, color: Colors.white),
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
          isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isSender) ...[
          CircleAvatar(
            backgroundImage: AssetImage(avatarUrl),
          ),
          SizedBox(width: 10),
        ],
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSender ? Color(0xff80CBC4) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isSender ? Radius.circular(0) : Radius.circular(12),
                bottomRight:
                    isSender ? Radius.circular(12) : Radius.circular(0),
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
        if (!isSender) ...[
          SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: AssetImage(avatarUrl),
          ),
        ],
      ],
    );
  }
}

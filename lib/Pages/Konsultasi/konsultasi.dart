import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/Pages/Konsultasi/roomchat.dart';
import 'package:mentorme/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KonsultasiPage extends StatefulWidget {
  @override
  _KonsultasiPageState createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage> {
  List<dynamic> chatRooms = [];
  bool isLoading = true;

  String currentUserName = '-';
  String currentUserEmail = '-';
  String currentUserRole = 'customer';

  Set<int> readRooms = {}; // ✅ Untuk menandai sudah dibaca

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadReadRooms(); // ✅ Load read rooms dari SharedPreferences
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserName = prefs.getString('nameUser') ?? '-';
      currentUserEmail = prefs.getString('emailUser') ?? '-';
    });
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    final url = Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/chat');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $currentUserToken',
          'Content-Type': 'application/json',
        },
      );
      final body = json.decode(response.body);
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

  // ✅ Simpan readRooms ke SharedPreferences
  Future<void> saveReadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'readRooms', readRooms.map((e) => e.toString()).toList());
  }

  // ✅ Load readRooms dari SharedPreferences
  Future<void> loadReadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRooms = prefs.getStringList('readRooms');
    if (savedRooms != null) {
      setState(() {
        readRooms = savedRooms.map((e) => int.tryParse(e) ?? 0).toSet();
      });
    }
  }

  // 🔥 (Optional) Reset readRooms untuk testing
  Future<void> resetReadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('readRooms');
    setState(() {
      readRooms.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0FFF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
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
                        // Cek jika nama mentor atau customer adalah 'admin', skip item
                        if (room['nameMentor'] == 'admin' ||
                            room['nameCustomer'] == 'admin') {
                          return SizedBox
                              .shrink(); // Tidak menampilkan apapun jika nama 'admin'
                        }
                        final isCurrentUserMentor =
                            room['nameMentor'] == currentUserName;
                        final myName = isCurrentUserMentor
                            ? room['nameMentor']
                            : room['nameCustomer'];
                        final myEmail = isCurrentUserMentor
                            ? room['emailMentor']
                            : room['emailCustomer'];
                        final myRole =
                            isCurrentUserMentor ? 'mentor' : 'customer';
                        final otherUserName = isCurrentUserMentor
                            ? room['nameCustomer']
                            : room['nameMentor'];
                        final otherUserRole =
                            isCurrentUserMentor ? 'Customer' : 'Mentor';

                        final isNewMessage =
                            room['lastSender'] != currentUserEmail &&
                                !readRooms.contains(room['idRoom']);

                        return Column(
                          children: [
                            _buildHistoryItem(
                              context,
                              otherUserName,
                              otherUserRole,
                              isNewMessage ? 'Pesan Baru' : 'Riwayat chat',
                              'assets/person.png',
                              room['idRoom'],
                              myName,
                              myEmail,
                              myRole,
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
            ),
          ),
          SizedBox(height: 8),
          // 🔥 Tombol Reset untuk Testing (bisa dihapus kalau gak perlu)
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
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomchatPage(
              roomId: idRoom,
              currentUserName: this.currentUserName,
              currentUserEmail: this.currentUserEmail,
            ),
          ),
        );

        // ✅ Setelah kembali dari RoomchatPage, tandai sudah dibaca
        setState(() {
          readRooms.add(idRoom);
        });
        saveReadRooms(); // ✅ Simpan ke SharedPreferences
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
                      color: status == 'Pesan Baru'
                          ? Colors.red
                          : Colors.grey[500],
                      fontSize: 12,
                      fontWeight: status == 'Pesan Baru'
                          ? FontWeight.bold
                          : FontWeight.normal,
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

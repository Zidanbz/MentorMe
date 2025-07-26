import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mentorme/features/consultation/roomchat.dart';

import 'package:mentorme/global/global.dart'; // Assuming this contains currentUserToken
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';
import 'package:mentorme/shared/widgets/optimized_list_view.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  _KonsultasiPageState createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> chatRooms = [];
  bool isLoading = true;

  String currentUserName = '-';
  String currentUserEmail = '-';
  // String currentUserRole = 'customer'; // This variable isn't used in the provided code, so it's commented out.

  Set<int> readRooms = {};

  // Animation controller for the header
  late AnimationController _headerAnimationController;
  late Animation<Offset> _headerOffsetAnimation;
  late Animation<double> _headerFadeAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeIn,
      ),
    );

    loadUserData();
    loadReadRooms();
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        currentUserName = prefs.getString('nameUser') ?? '-';
        currentUserEmail = prefs.getString('emailUser') ?? '-';
      });
    }
    await fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    // Show loading indicator if not already showing
    if (!isLoading && mounted) {
      setState(() {
        isLoading = true;
      });
    }

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
      if (mounted) {
        if (response.statusCode == 200 && body['data'] != null) {
          setState(() {
            chatRooms = body['data'];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          // Consider showing a toast or snackbar for error/no data
        }
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      // Handle error more gracefully, e.g., show an error message
      print('Error fetching chat rooms: $e');
    }
  }

  Future<void> saveReadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'readRooms', readRooms.map((e) => e.toString()).toList());
  }

  Future<void> loadReadRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRooms = prefs.getStringList('readRooms');
    if (savedRooms != null && mounted) {
      setState(() {
        readRooms = savedRooms.map((e) => int.tryParse(e) ?? 0).toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.lightBlue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).padding.top +
                    20), // Dynamic padding for status bar
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerOffsetAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Riwayat Chat',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black26,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: isLoading
                      ? _buildLoadingState()
                      : RefreshIndicator(
                          onRefresh: fetchChatRooms,
                          color: Colors.teal,
                          child: chatRooms.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.chat_bubble_outline,
                                          size: 80, color: Colors.grey[300]),
                                      SizedBox(height: 16),
                                      Text(
                                        'Belum ada riwayat chat.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                                  itemCount: chatRooms.length,
                                  itemBuilder: (context, index) {
                                    final room = chatRooms[index];
                                    if (room['nameMentor'] == 'admin' ||
                                        room['nameCustomer'] == 'admin') {
                                      return SizedBox
                                          .shrink(); // Hide admin rooms
                                    }

                                    final isCurrentUserMentor =
                                        room['nameMentor'] == currentUserName;
                                    final otherUserName = isCurrentUserMentor
                                        ? room['nameCustomer']
                                        : room['nameMentor'];
                                    final otherUserPicture = isCurrentUserMentor
                                        ? room['pictureCustomer']
                                        : room['pictureMentor'];
                                    final isNewMessage = room['lastSender'] !=
                                            currentUserEmail &&
                                        !readRooms.contains(room['idRoom']);

                                    return OptimizedFadeSlide(
                                      delay:
                                          Duration(milliseconds: index * 100),
                                      child: _buildHistoryItem(
                                        context,
                                        otherUserName,
                                        isNewMessage,
                                        otherUserPicture,
                                        room['idRoom'],
                                      ),
                                    );
                                  },
                                ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String name,
    bool isNewMessage,
    String? imageUrl,
    int idRoom,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isNewMessage ? Colors.teal.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (mounted) {
              setState(() {
                readRooms.add(idRoom);
              });
            }
            saveReadRooms(); // Save immediately when tapped
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomchatPage(
                  roomId: idRoom,
                  currentUserName: currentUserName,
                  currentUserEmail: currentUserEmail,
                ),
              ),
            );
            // After returning from RoomchatPage, refresh the list to reflect any new messages
            fetchChatRooms();
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                (imageUrl != null && imageUrl.isNotEmpty)
                    ? ClipOval(
                        child: OptimizedImage(
                          imageUrl: imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          placeholder: ShimmerCircle(radius: 32),
                          errorWidget: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.teal.shade100,
                            child: Icon(Icons.person,
                                color: Colors.teal.shade300, size: 32),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(Icons.person,
                            color: Colors.teal.shade300, size: 32),
                      ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        isNewMessage
                            ? 'Pesan baru!'
                            : 'Ketuk untuk melanjutkan chat',
                        style: TextStyle(
                          fontSize: 14,
                          color: isNewMessage
                              ? Colors.teal.shade700
                              : Colors.grey[600],
                          fontWeight: isNewMessage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isNewMessage)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                SizedBox(
                    width: isNewMessage
                        ? 8
                        : 0), // Add spacing only if new message indicator is present
                Icon(Icons.arrow_forward_ios,
                    color: Colors.grey[400], size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ShimmerCircle(radius: 32),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerText(width: 150, height: 19),
                      SizedBox(height: 4),
                      ShimmerText(width: 200, height: 14),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ShimmerText(width: 18, height: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

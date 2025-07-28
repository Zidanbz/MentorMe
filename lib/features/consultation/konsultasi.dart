import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mentorme/features/consultation/roomchat.dart';
import 'package:mentorme/features/consultation/services/consultation_api_service.dart';
import 'package:mentorme/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/optimized_list_view.dart';
import 'package:mentorme/global/Fontstyle.dart';

class KonsultasiPage extends StatefulWidget {
  const KonsultasiPage({super.key});

  @override
  _KonsultasiPageState createState() => _KonsultasiPageState();
}

class _KonsultasiPageState extends State<KonsultasiPage>
    with TickerProviderStateMixin {
  List<dynamic> chatRooms = [];
  bool isLoading = true;

  String currentUserName = '-';
  String currentUserEmail = '-';

  Set<int> readRooms = {};

  // Enhanced animation controllers
  late AnimationController _backgroundController;
  late AnimationController _headerController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _headerOffsetAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    loadUserData();
    loadReadRooms();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _headerOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.elasticOut,
    ));

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeIn,
      ),
    );

    _floatingAnimation = Tween<double>(
      begin: -20.0,
      end: 20.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _headerController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _headerController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
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
    if (!isLoading && mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final response = await ConsultationApiService.fetchChatRooms();

      if (mounted) {
        if (response.success && response.data != null) {
          setState(() {
            chatRooms = response.data!;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat chat rooms: ${response.message}'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching chat rooms: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(const Color(0xFF339989), const Color(0xFF3c493f),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFF3c493f), const Color(0xFFe0fff3),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFFe0fff3), const Color(0xFF339989),
                      _backgroundAnimation.value)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildFloatingElements(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 20),
                    _buildAnimatedHeader(),
                    const SizedBox(height: 24),
                    Expanded(child: _buildChatRoomsList()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              top: 200 - _floatingAnimation.value * 0.5,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFe0fff3).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 150 + _floatingAnimation.value * 0.8,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF339989).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.forum_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedHeader() {
    return FadeTransition(
      opacity: _headerFadeAnimation,
      child: SlideTransition(
        position: _headerOffsetAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFe0fff3)],
                      ).createShader(bounds),
                      child: Text(
                        'Riwayat Chat',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            const Shadow(
                              blurRadius: 8.0,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lanjutkan percakapan dengan mentor',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.chat_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lokasi: konsultasi_page.dart

  Widget _buildChatRoomsList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF339989).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: isLoading
            ? _buildLoadingState()
            : RefreshIndicator(
                onRefresh: fetchChatRooms,
                // [PERBAIKAN] Tambahkan baris ini untuk menyembunyikan lingkaran loading
                notificationPredicate: (notification) => false,
                child: chatRooms.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: chatRooms.length,
                        itemBuilder: (context, index) {
                          final room = chatRooms[index];
                          if (room['nameMentor'] == 'admin' ||
                              room['nameCustomer'] == 'admin') {
                            return const SizedBox.shrink();
                          }

                          final isCurrentUserMentor =
                              room['nameMentor'] == currentUserName;
                          final otherUserName = isCurrentUserMentor
                              ? room['nameCustomer']
                              : room['nameMentor'];
                          final otherUserPicture = isCurrentUserMentor
                              ? room['pictureCustomer']
                              : room['pictureMentor'];
                          final isNewMessage =
                              room['lastSender'] != currentUserEmail &&
                                  !readRooms.contains(room['idRoom']);

                          return enhanced.OptimizedFadeSlide(
                            delay: Duration(milliseconds: index * 100),
                            child: _buildHistoryItem(
                              context,
                              otherUserName,
                              isNewMessage,
                              otherUserPicture,
                              room['idRoom'],
                              index,
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  // [PERUBAHAN 2]
  Widget _buildEmptyState() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: enhanced.OptimizedFadeSlide(
              delay: const Duration(milliseconds: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  enhanced.OptimizedScale(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF339989), Color(0xFF3c493f)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF339989).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum ada riwayat chat',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: const Color(0xFF3c493f),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai konsultasi dengan mentor untuk\nmemulai percakapan pertama Anda',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF3c493f).withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHistoryItem(
    BuildContext context,
    String name,
    bool isNewMessage,
    String? imageUrl,
    int idRoom,
    int index,
  ) {
    return enhanced.OptimizedHover(
      scale: 1.02,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: isNewMessage
              ? const LinearGradient(
                  colors: [Color(0xFFe0fff3), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8FDFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isNewMessage
                ? const Color(0xFF339989).withOpacity(0.3)
                : const Color(0xFF339989).withOpacity(0.1),
            width: isNewMessage ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isNewMessage
                  ? const Color(0xFF339989).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              spreadRadius: isNewMessage ? 3 : 1,
              blurRadius: isNewMessage ? 15 : 8,
              offset: const Offset(0, 4),
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
              saveReadRooms();
              await Navigator.push(
                context,
                enhanced.OptimizedPageRoute(
                  child: RoomchatPage(
                    roomId: idRoom,
                    currentUserName: currentUserName,
                    currentUserEmail: currentUserEmail,
                  ),
                  transitionType: enhanced.PageTransitionType.slideRight,
                ),
              );
              fetchChatRooms();
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF339989), Color(0xFF3c493f)],
                          ),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? ClipOval(
                                child: OptimizedImage(
                                  imageUrl: imageUrl,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  placeholder: const ShimmerCircle(radius: 32),
                                  errorWidget: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: const Color(0xFFe0fff3),
                                    child: Icon(
                                      Icons.person,
                                      color: const Color(0xFF339989),
                                      size: 32,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 32,
                                backgroundColor: const Color(0xFFe0fff3),
                                child: Icon(
                                  Icons.person,
                                  color: const Color(0xFF339989),
                                  size: 32,
                                ),
                              ),
                      ),
                      if (isNewMessage)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF339989),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF3c493f),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isNewMessage
                                    ? const Color(0xFF339989)
                                    : const Color(0xFF339989).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isNewMessage ? 'Pesan baru!' : 'Lanjutkan chat',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isNewMessage
                                      ? Colors.white
                                      : const Color(0xFF339989),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  enhanced.OptimizedHover(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF339989).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: const Color(0xFF339989),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return enhanced.OptimizedFadeSlide(
          delay: Duration(milliseconds: index * 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF339989).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const ShimmerCircle(radius: 32),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerText(
                          width: 150,
                          height: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        ShimmerText(
                          width: 100,
                          height: 14,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  ShimmerText(
                    width: 16,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

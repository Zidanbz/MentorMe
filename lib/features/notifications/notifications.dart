import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/global/Fontstyle.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with TickerProviderStateMixin {
  List<AppNotification> notifications = [];
  bool isLoading = true;
  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    fetchNotifications();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('https://widgets22-catb7yz54a-et.a.run.app/api/notif/all'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 200 && data['data'] != null) {
          setState(() {
            notifications = (data['data'] as List)
                .map((notification) => AppNotification.fromJson(notification))
                .toList()
              ..sort((a, b) =>
                  b.createdAt.compareTo(a.createdAt)); // Urutkan dari terbaru
            isLoading = false;
          });
        } else {
          print('API Error: ${data['message']}');
          setState(() => isLoading = false);
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Fetch Error: $e');
      setState(() => isLoading = false);
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(const Color(0xFF339989), const Color(0xFFe0fff3),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFFe0fff3), const Color(0xFF3c493f),
                      _backgroundAnimation.value)!,
                  Color.lerp(const Color(0xFF3c493f), const Color(0xFF339989),
                      _backgroundAnimation.value)!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                _buildFloatingElements(),
                _buildContent(),
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
              top: 120 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFe0fff3).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              top: 250 - _floatingAnimation.value,
              left: 20,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 200 + _floatingAnimation.value,
              right: 40,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3c493f).withOpacity(0.1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: isLoading
                ? _buildLoadingState()
                : notifications.isEmpty
                    ? _buildEmptyState()
                    : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return enhanced.OptimizedFadeSlide(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            enhanced.OptimizedHover(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Notifikasi',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: enhanced.OptimizedScale(
        duration: const Duration(milliseconds: 800),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: enhanced.OptimizedFadeSlide(
        delay: const Duration(milliseconds: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            enhanced.OptimizedScale(
              duration: const Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tidak ada notifikasi',
              style: AppTextStyles.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Semua notifikasi akan muncul di sini',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      onRefresh: fetchNotifications,
      color: const Color(0xFF339989),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return enhanced.OptimizedFadeSlide(
              delay: Duration(milliseconds: 100 * index),
              child: NotificationCard(
                notification: notifications[index],
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final int index;

  NotificationCard({required this.notification, required this.index});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd MMM yyyy, HH:mm').format(notification.createdAt);

    return enhanced.OptimizedHover(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF339989).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF339989), Color(0xFF3c493f)],
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFe0fff3),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/Maskot.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF3c493f).withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF339989).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            formattedDate,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: const Color(0xFF339989),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (notification.actionText != null)
                          enhanced.OptimizedHover(
                            scale: 1.05,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF339989),
                                    Color(0xFF3c493f)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF339989)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    // Aksi ketika tombol diklik
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Text(
                                      notification.actionText!,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? actionText;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.actionText,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;

    if (json['timestamp'] is String) {
      parsedDate = DateTime.parse(json['timestamp']);
    } else if (json['timestamp'] != null &&
        json['timestamp']['_seconds'] != null) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(
          json['timestamp']['_seconds'] * 1000);
    } else {
      parsedDate = DateTime.now();
    }

    return AppNotification(
      id: json['ID']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Tanpa Judul',
      message: json['message']?.toString() ?? 'Tidak ada pesan',
      createdAt: parsedDate,
      actionText: json['actionText']?.toString(),
    );
  }
}

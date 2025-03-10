class AppNotification {
  // Changed from Notification to AppNotification
  final String id;
  final String title;
  final String message;

  AppNotification(
      {required this.id, required this.title, required this.message});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['ID'],
      title: json['title'],
      message: json['message'],
    );
  }
}

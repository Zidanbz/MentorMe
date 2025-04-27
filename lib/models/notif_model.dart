class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt; // Tambahkan field timestamp

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['ID'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      message: json['message'] ?? 'Tidak ada pesan',
      createdAt: DateTime.parse(json['createdAt']), // Pastikan API mengirim field ini
    );
  }
}
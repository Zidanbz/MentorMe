class LearningPath {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  LearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  // Untuk parsing dari JSON (kalau ambil dari API atau Firestore)
  factory LearningPath.fromJson(Map<String, dynamic> json) {
    return LearningPath(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

class Profile {
  final String fullName;
  final String picture;

  Profile({
    required this.fullName,
    required this.picture, // Menangani gambar sebagai URL
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      fullName: json['fullName'] ?? '',
      picture: json['picture'] ?? '', // Ambil URL gambar sebagai string
    );
  }
}

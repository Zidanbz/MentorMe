// Lokasi: models/Profile_models.dart

class Profile {
  final String fullName;
  final String picture;
  final String? phone;

  Profile({
    required this.fullName,
    required this.picture,
    this.phone,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    // [TAMBAHKAN DEBUG PRINT FINAL DI SINI]
    print('--- DATA YANG DITERIMA FROMJSON ---');
    print(json);
    print('---------------------------------');

    return Profile(
      // Pastikan key di sini sama persis dengan yang ada di output debug
      fullName: json['fullName'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

import 'dart:typed_data';

class Getname {
  final String fullName;
  final Uint8List? picture; // Ubah ke Uint8List untuk gambar file

  Getname({
    required this.fullName,
    this.picture,
  });

  factory Getname.fromJson(Map<String, dynamic> json) {
    return Getname(
      fullName: json['fullName'] ?? '',
      picture:
          json['picture'] != null ? Uint8List.fromList(json['picture']) : null,
    );
  }
}

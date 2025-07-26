class Profile {
  final String fullName;
  final String picture;
  final String? phone;
  // Anda bisa tambahkan field lain jika perlu, contoh: email, job, dll.
  // final String? email;

  Profile({
    required this.fullName,
    required this.picture,
    this.phone,
    // this.email,
  });

  // --- Perbaikan ada di sini ---
  factory Profile.fromJson(Map<String, dynamic> json) {
    // 1. Akses objek 'data' yang ada di dalam JSON
    final data = json['data'] as Map<String, dynamic>?;

    return Profile(
      // 2. Ambil setiap nilai dari DALAM 'data'
      fullName: data?['fullName'] as String? ?? '',
      picture: data?['picture'] as String? ?? '',

      // 3. Ambil 'phone', ubah ke String, dan beri nilai default jika null
      phone: data?['phone']?.toString() ?? '',

      // email: data?['email'] as String? ?? '', // Contoh jika mau tambah email
    );
  }
}

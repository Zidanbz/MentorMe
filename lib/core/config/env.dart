class Env {
  /// Base URL untuk API utama
  static const String baseUrl = _prodBaseUrl;

  /// Untuk pengembangan, kamu bisa ganti `_prodBaseUrl` jadi `_devBaseUrl`
  static const String _devBaseUrl =
      'http://localhost:3000/api'; // untuk development lokal
  static const String _prodBaseUrl =
      'https://widgets22-catb7yz54a-et.a.run.app/api'; // production
}

import 'package:flutter/material.dart';
import 'package:mentorme/shared/widgets/app_background.dart';
import 'package:mentorme/global/Fontstyle.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Column(
          children: [
            // Custom App Bar
            SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF339989).withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF3c493f),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF339989), Color(0xFF3c493f)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Syarat & Ketentuan',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF339989).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'Selamat Datang di MentorMe',
                        'Dengan menggunakan aplikasi MentorMe, Anda menyetujui syarat dan ketentuan berikut. Harap baca dengan seksama sebelum menggunakan layanan kami.',
                      ),
                      _buildSection(
                        '1. Definisi',
                        '• "MentorMe" mengacu pada platform pembelajaran online yang menyediakan layanan mentoring dan kursus.\n'
                            '• "Pengguna" mengacu pada setiap individu yang mengakses atau menggunakan layanan MentorMe.\n'
                            '• "Mentor" mengacu pada instruktur atau pengajar yang menyediakan konten pembelajaran.\n'
                            '• "Konten" mengacu pada semua materi pembelajaran, video, teks, dan sumber daya lainnya.',
                      ),
                      _buildSection(
                        '2. Penggunaan Layanan',
                        '• Anda harus berusia minimal 13 tahun untuk menggunakan layanan ini.\n'
                            '• Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda.\n'
                            '• Dilarang menggunakan layanan untuk tujuan ilegal atau melanggar hukum.\n'
                            '• Anda tidak diperkenankan membagikan akun dengan orang lain.',
                      ),
                      _buildSection(
                        '3. Konten dan Hak Kekayaan Intelektual',
                        '• Semua konten di MentorMe dilindungi oleh hak cipta dan hak kekayaan intelektual.\n'
                            '• Anda tidak diperkenankan menyalin, mendistribusikan, atau menggunakan konten tanpa izin.\n'
                            '• Konten yang Anda unggah tetap menjadi milik Anda, namun Anda memberikan lisensi kepada MentorMe untuk menggunakannya.',
                      ),
                      _buildSection(
                        '4. Pembayaran dan Pengembalian Dana',
                        '• Semua pembayaran harus dilakukan melalui metode yang tersedia di aplikasi.\n'
                            '• Pengembalian dana dapat dilakukan sesuai dengan kebijakan yang berlaku.\n'
                            '• Harga dapat berubah sewaktu-waktu tanpa pemberitahuan sebelumnya.\n'
                            '• Transaksi yang telah selesai tidak dapat dibatalkan kecuali dalam kondisi tertentu.',
                      ),
                      _buildSection(
                        '5. Privasi dan Data',
                        '• Kami menghormati privasi Anda dan melindungi data pribadi sesuai kebijakan privasi.\n'
                            '• Data yang dikumpulkan digunakan untuk meningkatkan layanan dan pengalaman pengguna.\n'
                            '• Kami tidak akan membagikan data pribadi kepada pihak ketiga tanpa persetujuan Anda.',
                      ),
                      _buildSection(
                        '6. Pembatasan Tanggung Jawab',
                        '• MentorMe tidak bertanggung jawab atas kerugian yang timbul dari penggunaan layanan.\n'
                            '• Layanan disediakan "sebagaimana adanya" tanpa jaminan apapun.\n'
                            '• Kami tidak menjamin ketersediaan layanan 24/7 tanpa gangguan.',
                      ),
                      _buildSection(
                        '7. Penangguhan dan Penghentian',
                        '• Kami berhak menangguhkan atau menghentikan akun yang melanggar syarat dan ketentuan.\n'
                            '• Pengguna dapat menghentikan akun kapan saja dengan menghubungi layanan pelanggan.\n'
                            '• Data akun yang dihentikan akan dihapus sesuai kebijakan retensi data.',
                      ),
                      _buildSection(
                        '8. Perubahan Syarat dan Ketentuan',
                        '• MentorMe berhak mengubah syarat dan ketentuan sewaktu-waktu.\n'
                            '• Perubahan akan diberitahukan melalui aplikasi atau email.\n'
                            '• Penggunaan berkelanjutan setelah perubahan dianggap sebagai persetujuan.',
                      ),
                      _buildSection(
                        '9. Hukum yang Berlaku',
                        'Syarat dan ketentuan ini diatur oleh hukum Republik Indonesia. Setiap sengketa akan diselesaikan melalui pengadilan yang berwenang di Indonesia.',
                      ),
                      _buildSection(
                        '10. Kontak',
                        'Jika Anda memiliki pertanyaan tentang syarat dan ketentuan ini, silakan hubungi kami melalui:\n\n'
                            'Email: mentormeid1@gmail.com\n'
                            'Telepon: +62 85 1830 60349\n'
                            'Alamat: Makassar, Indonesia',
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF339989), Color(0xFF3c493f)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Terakhir diperbarui: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3c493f),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF3c493f).withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

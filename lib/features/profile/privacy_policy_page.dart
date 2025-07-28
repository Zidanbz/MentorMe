import 'package:flutter/material.dart';
import 'package:mentorme/shared/widgets/app_background.dart';
import 'package:mentorme/global/Fontstyle.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                      'Kebijakan Privasi',
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
                        'Kebijakan Privasi MentorMe',
                        'Kami di MentorMe berkomitmen untuk melindungi privasi dan keamanan data pribadi Anda. Kebijakan privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.',
                      ),
                      _buildSection(
                        '1. Informasi yang Kami Kumpulkan',
                        'Kami mengumpulkan berbagai jenis informasi untuk memberikan layanan terbaik:\n\n'
                            '• Informasi Pribadi: Nama, alamat email, nomor telepon, tanggal lahir\n'
                            '• Informasi Akun: Username, password (terenkripsi), preferensi pembelajaran\n'
                            '• Informasi Pembayaran: Detail kartu kredit/debit, riwayat transaksi\n'
                            '• Data Penggunaan: Aktivitas pembelajaran, progress kursus, waktu akses\n'
                            '• Informasi Teknis: Alamat IP, jenis perangkat, browser, sistem operasi',
                      ),
                      _buildSection(
                        '2. Bagaimana Kami Menggunakan Informasi',
                        'Informasi yang dikumpulkan digunakan untuk:\n\n'
                            '• Menyediakan dan meningkatkan layanan pembelajaran\n'
                            '• Memproses pembayaran dan transaksi\n'
                            '• Mengirimkan notifikasi dan update penting\n'
                            '• Memberikan dukungan pelanggan\n'
                            '• Menganalisis penggunaan untuk pengembangan fitur\n'
                            '• Mencegah penipuan dan aktivitas mencurigakan\n'
                            '• Mematuhi kewajiban hukum',
                      ),
                      _buildSection(
                        '3. Berbagi Informasi',
                        'Kami tidak menjual atau menyewakan data pribadi Anda. Informasi hanya dibagikan dalam situasi berikut:\n\n'
                            '• Dengan persetujuan eksplisit Anda\n'
                            '• Kepada penyedia layanan pihak ketiga yang membantu operasional kami\n'
                            '• Untuk mematuhi kewajiban hukum atau perintah pengadilan\n'
                            '• Dalam situasi darurat untuk melindungi keselamatan\n'
                            '• Dalam proses merger atau akuisisi perusahaan',
                      ),
                      _buildSection(
                        '4. Keamanan Data',
                        'Kami menerapkan langkah-langkah keamanan yang ketat:\n\n'
                            '• Enkripsi data saat transmisi dan penyimpanan\n'
                            '• Akses terbatas hanya untuk karyawan yang berwenang\n'
                            '• Pemantauan sistem keamanan 24/7\n'
                            '• Audit keamanan berkala\n'
                            '• Backup data secara teratur\n'
                            '• Sertifikasi keamanan internasional',
                      ),
                      _buildSection(
                        '5. Cookies dan Teknologi Pelacakan',
                        'Kami menggunakan cookies dan teknologi serupa untuk:\n\n'
                            '• Mengingat preferensi dan pengaturan Anda\n'
                            '• Menganalisis pola penggunaan aplikasi\n'
                            '• Memberikan konten yang dipersonalisasi\n'
                            '• Meningkatkan keamanan akun\n\n'
                            'Anda dapat mengatur preferensi cookies melalui pengaturan browser atau aplikasi.',
                      ),
                      _buildSection(
                        '6. Hak-Hak Anda',
                        'Sebagai pengguna, Anda memiliki hak untuk:\n\n'
                            '• Mengakses data pribadi yang kami simpan\n'
                            '• Memperbarui atau mengoreksi informasi yang tidak akurat\n'
                            '• Menghapus akun dan data pribadi\n'
                            '• Membatasi pemrosesan data tertentu\n'
                            '• Memindahkan data ke layanan lain\n'
                            '• Menolak pemrosesan untuk tujuan pemasaran\n'
                            '• Mengajukan keluhan kepada otoritas perlindungan data',
                      ),
                      _buildSection(
                        '7. Penyimpanan Data',
                        'Data pribadi Anda disimpan selama:\n\n'
                            '• Akun aktif: Selama akun Anda masih aktif\n'
                            '• Setelah penghapusan akun: Hingga 30 hari untuk keperluan backup\n'
                            '• Data transaksi: 7 tahun sesuai ketentuan perpajakan\n'
                            '• Data analitik: Dalam bentuk anonim untuk penelitian\n\n'
                            'Anda dapat meminta penghapusan data lebih cepat dengan menghubungi kami.',
                      ),
                      _buildSection(
                        '8. Transfer Data Internasional',
                        'Data Anda mungkin diproses di server yang berlokasi di luar Indonesia. Kami memastikan:\n\n'
                            '• Negara tujuan memiliki tingkat perlindungan data yang memadai\n'
                            '• Kontrak dengan penyedia layanan mencakup klausul perlindungan data\n'
                            '• Enkripsi data selama transfer\n'
                            '• Kepatuhan terhadap standar internasional',
                      ),
                      _buildSection(
                        '9. Privasi Anak',
                        'Kami berkomitmen melindungi privasi anak-anak:\n\n'
                            '• Tidak mengumpulkan data dari anak di bawah 13 tahun tanpa persetujuan orang tua\n'
                            '• Fitur khusus untuk akun anak dengan kontrol orang tua\n'
                            '• Pembatasan iklan dan konten yang tidak sesuai\n'
                            '• Proses verifikasi usia yang ketat',
                      ),
                      _buildSection(
                        '10. Perubahan Kebijakan',
                        'Kebijakan privasi ini dapat berubah sewaktu-waktu. Kami akan:\n\n'
                            '• Memberitahu Anda melalui email atau notifikasi aplikasi\n'
                            '• Memberikan waktu 30 hari untuk meninjau perubahan\n'
                            '• Meminta persetujuan ulang jika diperlukan\n'
                            '• Menyimpan versi sebelumnya untuk referensi',
                      ),
                      _buildSection(
                        '11. Hubungi Kami',
                        'Jika Anda memiliki pertanyaan tentang kebijakan privasi atau ingin menggunakan hak-hak Anda:\n\n'
                            'Email: mentormeid1@gmail.com\n'
                            'Telepon: +62 85 1830 60349 \n'
                            'Alamat: Makassar, Indonesia\n\n'
                            'Data Protection Officer:\n'
                            'Email: mentormeid1@gmail.com\n\n'
                            'Kami akan merespons dalam waktu 14 hari kerja.',
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
                        child: Column(
                          children: [
                            Text(
                              'Terakhir diperbarui: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Dengan menggunakan MentorMe, Anda menyetujui kebijakan privasi ini.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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

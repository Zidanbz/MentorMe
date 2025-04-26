import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Payment/succes_payment.dart';
import 'package:mentorme/controller/api_services.dart';

class WaitingPaymentScreen extends StatefulWidget {
  final String transactionId;

  const WaitingPaymentScreen({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<WaitingPaymentScreen> createState() => _WaitingPaymentScreenState();
}

class _WaitingPaymentScreenState extends State<WaitingPaymentScreen> {
  Timer? _pollingTimer;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final response = await ApiService().fetchProfileHistory();
      debugPrint("📦 Full response: $response");

      final history = response['history'] as List<dynamic>?;

      if (history == null) {
        debugPrint("📭 Data dari API kosong / null");
        return;
      }

      final transactionIdTarget = widget.transactionId.trim().toLowerCase();

      for (var item in history) {
        final status = item['status']?.toString().toLowerCase();
        final transactionIdFromApi =
            item['transactionID']?.toString().trim().toLowerCase();

        debugPrint(
            "🧩 Cek TransactionID: $transactionIdFromApi | Status: $status");

        if (transactionIdFromApi == transactionIdTarget) {
          if (status == 'accept') {
            _pollingTimer?.cancel();

            if (!_isNavigated && mounted) {
              _isNavigated = true;
              debugPrint(
                  "🎉 Pembayaran berhasil! Navigasi ke PaymentSuccessScreen...");
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const PaymentSuccessScreen(),
                ),
              );
            }
          } else if (status == 'pending') {
            debugPrint("🕐 Pembayaran masih pending, akan dicek kembali...");
            // Biarkan polling berjalan terus
          } else {
            debugPrint(
                "⚠️ Status transaksi tidak dikenal atau tidak diproses: $status");
            // Tambahkan penanganan lain jika dibutuhkan (misalnya failed, expired, dll)
          }

          break; // Keluar dari loop setelah menemukan transaksi yang sesuai
        }
      }
    } catch (e) {
      debugPrint("⚠️ Error saat cek status pembayaran: $e");
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffE0FFF3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xff339989),
            ),
            SizedBox(height: 20),
            Text(
              'Menunggu konfirmasi pembayaran...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Silakan selesaikan pembayaran Anda di halaman berikutnya',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

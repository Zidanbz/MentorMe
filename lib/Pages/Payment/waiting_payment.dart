import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Payment/succes_payment.dart';
import 'package:mentorme/controller/api_services.dart';

class WaitingPaymentScreen extends StatefulWidget {
  final String projectId;

  const WaitingPaymentScreen({Key? key, required this.projectId})
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
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
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

      final projectIdTarget = widget.projectId.trim().toLowerCase();

      for (var item in history) {
        final status = item['status']?.toString().toLowerCase();
        final projectIdFromApi =
            item['project']?['ID']?.toString().trim().toLowerCase();

        debugPrint("🧩 Cek Project: $projectIdFromApi | Status: $status");

        if (projectIdFromApi == projectIdTarget && status == 'accept') {
          _pollingTimer?.cancel();

          if (!_isNavigated) {
            _isNavigated = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const PaymentSuccessScreen(),
              ),
            );
          }
          break;
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

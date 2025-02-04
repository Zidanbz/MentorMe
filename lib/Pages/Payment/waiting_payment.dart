import 'package:flutter/material.dart';
import 'package:mentorme/Pages/Payment/succes_payment.dart';
import 'package:mentorme/controller/api_services.dart';
import 'package:mentorme/providers/payment_provider.dart';
import 'failed_payment.dart';

class WaitingPaymentScreen extends StatefulWidget {
  final String projectId;

  const WaitingPaymentScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _WaitingPaymentScreenState createState() => _WaitingPaymentScreenState();
}

class _WaitingPaymentScreenState extends State<WaitingPaymentScreen> {
  final PaymentProvider _paymentProvider = PaymentProvider();
  bool isChecking = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final response =
          await _paymentProvider.getHistoryTransaction(widget.projectId);
      print("\ud83d\udccc Response check payment: $response");

      if (response != null && response['code'] == 200) {
        String status = response['data']['status'];
        print("Status Pembayaran: $status");

        if (status == 'accept') {
          print("Pembayaran diterima, pindah ke SuccessScreen");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
          );
        } else if (status == 'pending') {
          print("Pembayaran pending, pindah ke FailedScreen");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PaymentFailedScreen()),
          );
        } else {
          print("Status tidak dikenali, tetap di halaman pengecekan.");
          setState(() {
            isChecking = false;
          });
        }
      } else {
        setState(() {
          error = "Gagal memeriksa status pembayaran.";
        });
      }
    } catch (e) {
      setState(() {
        error = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pembayaran',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                isChecking
                    ? CircularProgressIndicator(
                        color: Colors.teal,
                        strokeWidth: 6.0,
                      )
                    : error != null
                        ? Column(
                            children: [
                              Text(error!, textAlign: TextAlign.center),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _checkPaymentStatus,
                                child: Text("Coba Lagi"),
                              ),
                            ],
                          )
                        : Text(
                            'Menunggu pembayaran...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                _checkPaymentStatus();
              },
              child: Center(
                child: Text(
                  'Periksa Status',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

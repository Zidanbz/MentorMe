import 'package:flutter/material.dart';
import 'package:mentorme/providers/payment_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TopUpCoinMeScreen extends StatefulWidget {
  @override
  _TopUpCoinMeScreenState createState() => _TopUpCoinMeScreenState();
}

class _TopUpCoinMeScreenState extends State<TopUpCoinMeScreen> {
  String amount = "500"; // Default jumlah CoinMe
  bool isLoading = true;
  String? error;
  final PaymentProvider _paymentProvider = PaymentProvider();

  void addDigit(String digit) {
    setState(() {
      if (amount == "0") {
        amount = digit;
      } else {
        amount += digit;
      }
    });
  }

  void deleteDigit() {
    setState(() {
      if (amount.isNotEmpty) {
        amount = amount.substring(0, amount.length - 1);
        if (amount.isEmpty) {
          amount = "0";
        }
      }
    });
  }

  Future<void> handleTopUp() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await _paymentProvider.topUpCoin(int.parse(amount));
      print("API Response: $response");
      if (response['code'] == 201) {
        if (response['data'] != null &&
            response['data']['redirect_url'] != null) {
          final String redirectUrl = response['data']['redirect_url'];
          print("Redirecting to: $redirectUrl");
          if (await canLaunch(redirectUrl)) {
            await launchUrl(Uri.parse(redirectUrl),
                mode: LaunchMode.externalApplication); // Membuka URL di browser
          } else {
            throw 'Tidak dapat membuka URL: $redirectUrl';
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Top-up berhasil!")),
          );
        }
      } else {
        print("Response API: $response");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal top-up: ${response['error']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Top Up CoinMe',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Display area
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '1000 CoinMe = Rp. 10.000',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/Coin.png', width: 30),
                      SizedBox(width: 10),
                      Text(
                        'CoinMe = $amount',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$amount = Rp. ${int.parse(amount) * 10}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Keypad
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 12, // Numbers + backspace
              itemBuilder: (context, index) {
                if (index == 9) {
                  return SizedBox.shrink(); // Empty slot
                } else if (index == 11) {
                  return GestureDetector(
                    onTap: deleteDigit,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.backspace, color: Colors.black),
                    ),
                  );
                } else {
                  String number = index == 10 ? "0" : (index + 1).toString();
                  return GestureDetector(
                    onTap: () => addDigit(number),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        number,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          // Swipe button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onHorizontalDragEnd: (details) async {
                await handleTopUp();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Coin.png', width: 30),
                    SizedBox(width: 10),
                    Text(
                      'Top Up CoinMe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

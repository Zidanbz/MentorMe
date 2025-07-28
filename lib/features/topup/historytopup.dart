import 'package:flutter/material.dart';

class HistoryCoinMeScreen extends StatefulWidget {
  @override
  _HistoryCoinMeScreenState createState() => _HistoryCoinMeScreenState();
}

class _HistoryCoinMeScreenState extends State<HistoryCoinMeScreen> {
  String selectedDate = "22 Okt 2024";

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
          'History CoinMe',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for Date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedDate,
                  icon: Icon(Icons.arrow_drop_down),
                  items: ["22 Okt 2024", "21 Okt 2024", "20 Okt 2024"]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDate = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Coin Balance Display
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Coin.png', width: 40),
                    SizedBox(width: 10),
                    Text(
                      '500',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // History Details
            Text(
              'Rincian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  historyItem('Konsultasi', '-10C'),
                  historyItem('Top-Up', '+100C'),
                  historyItem('Konsultasi', '-10C'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for a history item
  Widget historyItem(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              color: amount.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

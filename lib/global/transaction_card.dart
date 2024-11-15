import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isSuccess;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    this.isSuccess = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.people,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isSuccess ? 'Transaksi Selesai' : 'Transaksi Gagal',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Rp. $amount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF339989),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

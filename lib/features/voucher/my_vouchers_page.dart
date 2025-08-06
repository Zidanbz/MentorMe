import 'package:flutter/material.dart';
import 'package:mentorme/providers/payment_provider.dart';

class MyVouchersPage extends StatefulWidget {
  const MyVouchersPage({Key? key}) : super(key: key);

  @override
  State<MyVouchersPage> createState() => _MyVouchersPageState();
}

class _MyVouchersPageState extends State<MyVouchersPage> {
  final PaymentProvider _paymentProvider = PaymentProvider();
  List<Map<String, dynamic>> myVouchers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyVouchers();
  }

  Future<void> _loadMyVouchers() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _paymentProvider.getMyVouchers();
      print("📌 My vouchers response: $response");

      if (response != null &&
          (response['code'] == 200 || response['code'] == 201) &&
          response['data'] is List) {
        setState(() {
          myVouchers = List<Map<String, dynamic>>.from(response['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Gagal memuat voucher Anda');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("❌ Error loading my vouchers: $e");
      _showErrorSnackBar('Terjadi kesalahan saat memuat voucher');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatDate(dynamic dateData) {
    try {
      if (dateData is Map && dateData.containsKey('_seconds')) {
        final timestamp = dateData['_seconds'] * 1000;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return "${date.day}/${date.month}/${date.year}";
      } else if (dateData is String) {
        final date = DateTime.parse(dateData);
        return "${date.day}/${date.month}/${date.year}";
      }
      return "Invalid Date";
    } catch (e) {
      return "Invalid Date";
    }
  }

  bool _isVoucherExpired(dynamic dateEndData) {
    try {
      DateTime dateEnd;
      if (dateEndData is Map && dateEndData.containsKey('_seconds')) {
        final timestamp = dateEndData['_seconds'] * 1000;
        dateEnd = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (dateEndData is String) {
        dateEnd = DateTime.parse(dateEndData);
      } else {
        return true;
      }
      return DateTime.now().isAfter(dateEnd);
    } catch (e) {
      return true;
    }
  }

  Widget _buildVoucherCard(Map<String, dynamic> voucher) {
    final bool isUsed = voucher['isUsed'] ?? false;
    final bool isExpired = _isVoucherExpired(voucher['dateEnd']);
    final bool isActive = !isUsed && !isExpired && (voucher['status'] ?? false);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isUsed) {
      statusColor = Colors.grey;
      statusText = 'Sudah Digunakan';
      statusIcon = Icons.check_circle;
    } else if (isExpired) {
      statusColor = Colors.red;
      statusText = 'Kedaluwarsa';
      statusIcon = Icons.access_time;
    } else if (!isActive) {
      statusColor = Colors.orange;
      statusText = 'Tidak Aktif';
      statusIcon = Icons.warning;
    } else {
      statusColor = Colors.green;
      statusText = 'Dapat Digunakan';
      statusIcon = Icons.check_circle_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [Colors.white, const Color(0xFFF8F9FA)]
                : [Colors.grey.shade100, Colors.grey.shade200],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher['name'] ?? 'Voucher',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? const Color(0xFF2D3436)
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Diskon ${voucher['piece']}%',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 12,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (voucher['info'] != null &&
                voucher['info'].toString().isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  voucher['info'],
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF636E72)
                        : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF636E72),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Berlaku: ${_formatDate(voucher['dateStart'])} - ${_formatDate(voucher['dateEnd'])}',
                      style: const TextStyle(
                        color: Color(0xFF636E72),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF636E72),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Diklaim: ${_formatDate(voucher['claimedAt'])}',
                      style: const TextStyle(
                        color: Color(0xFF636E72),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (isUsed && voucher['usedAt'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF636E72),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Digunakan: ${_formatDate(voucher['usedAt'])}',
                        style: const TextStyle(
                          color: Color(0xFF636E72),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voucher Saya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6C5CE7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : myVouchers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard_outlined,
                          size: 80,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada voucher',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Klaim voucher untuk mendapatkan diskon menarik',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadMyVouchers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: myVouchers.length,
                      itemBuilder: (context, index) {
                        return _buildVoucherCard(myVouchers[index]);
                      },
                    ),
                  ),
      ),
    );
  }
}

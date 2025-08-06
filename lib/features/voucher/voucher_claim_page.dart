import 'package:flutter/material.dart';
import 'package:mentorme/providers/payment_provider.dart';

class VoucherClaimPage extends StatefulWidget {
  const VoucherClaimPage({Key? key}) : super(key: key);

  @override
  State<VoucherClaimPage> createState() => _VoucherClaimPageState();
}

class _VoucherClaimPageState extends State<VoucherClaimPage> {
  final PaymentProvider _paymentProvider = PaymentProvider();
  List<Map<String, dynamic>> availableVouchers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableVouchers();
  }

  Future<void> _loadAvailableVouchers() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _paymentProvider.getAvailableVouchersToClaim();
      print("📌 Available vouchers response: $response");

      if (response != null &&
          (response['code'] == 200 || response['code'] == 201) &&
          response['data'] is List) {
        setState(() {
          availableVouchers = List<Map<String, dynamic>>.from(response['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Gagal memuat voucher yang tersedia');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("❌ Error loading available vouchers: $e");
      _showErrorSnackBar('Terjadi kesalahan saat memuat voucher');
    }
  }

  Future<void> _claimVoucher(String voucherId, String voucherName) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Mengklaim voucher..."),
              ],
            ),
          );
        },
      );

      final response = await _paymentProvider.claimVoucher(voucherId);
      print("📌 Claim voucher response: $response");

      // Close loading dialog
      Navigator.of(context).pop();

      if (response != null &&
          (response['code'] == 200 || response['code'] == 201)) {
        _showSuccessSnackBar('Voucher "$voucherName" berhasil diklaim!');
        // Refresh the list
        _loadAvailableVouchers();
      } else {
        _showErrorSnackBar(response['error'] ?? 'Gagal mengklaim voucher');
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      print("❌ Error claiming voucher: $e");
      _showErrorSnackBar('Terjadi kesalahan saat mengklaim voucher');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(dynamic dateData) {
    try {
      if (dateData is Map && dateData.containsKey('_seconds')) {
        final timestamp = dateData['_seconds'] * 1000;
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return "${date.day}/${date.month}/${date.year}";
      }
      return "Invalid Date";
    } catch (e) {
      return "Invalid Date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Klaim Voucher',
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
            : availableVouchers.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 80,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada voucher yang tersedia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Semua voucher sudah diklaim atau tidak ada voucher aktif',
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
                    onRefresh: _loadAvailableVouchers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: availableVouchers.length,
                      itemBuilder: (context, index) {
                        final voucher = availableVouchers[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Color(0xFFF8F9FA)],
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
                                        color: const Color(0xFF6C5CE7)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.card_giftcard,
                                        color: Color(0xFF6C5CE7),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            voucher['name'] ?? 'Voucher',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D3436),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                      style: const TextStyle(
                                        color: Color(0xFF636E72),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
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
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _claimVoucher(
                                      voucher['ID'],
                                      voucher['name'] ?? 'Voucher',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6C5CE7),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                    ),
                                    child: const Text(
                                      'Klaim Voucher',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

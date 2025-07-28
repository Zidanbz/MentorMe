import 'package:flutter/material.dart';
import 'package:mentorme/features/payment/waiting_payment.dart';
import 'package:mentorme/providers/payment_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mentorme/shared/widgets/optimized_image.dart';
import 'package:mentorme/shared/widgets/optimized_shimmer.dart';
import 'package:mentorme/shared/widgets/optimized_animations.dart';
import 'package:mentorme/shared/widgets/optimized_list_view.dart';

class PaymentDetailPage extends StatefulWidget {
  final String projectId;

  const PaymentDetailPage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  String? selectedVoucher;
  bool isLoading = true;
  String? error;

  // Data yang akan diisi dari API
  String? materialName;
  int? syllabus;
  int? price;

  // Data dummy untuk voucher
  final List<Map<String, dynamic>> voucherList = [];

  final PaymentProvider _paymentProvider = PaymentProvider();

  @override
  void initState() {
    super.initState();
    _loadPaymentDetails();
  }

  Future<void> _loadPaymentDetails() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print("Memulai request ke API..."); // Debugging awal
      final response = await _paymentProvider.getPraPayment(widget.projectId);
      print("📌 projectId yang dikirim: ${widget.projectId}");
      print("Response API: $response"); // Debugging response
      setState(() {
        if (response != null) {
          // Periksa apakah response tidak null terlebih dahulu
          if (response['code'] == 200 && response['data'] != null) {
            materialName =
                response['data']['materialName'] ?? 'Material tidak tersedia';
            syllabus = response['data']['syllabus'] ?? 0;
            price = int.tryParse(response['data']['price']) ?? 0;
            // error = null; // Reset error jika data berhasil diambil
          } else {
            // Tangani kasus ketika code bukan 200 atau data null
            String errorMessage =
                'Data tidak ditemukan atau format tidak valid';
            if (response['error'] != null) {
              errorMessage =
                  response['error']; // Ambil pesan error dari response jika ada
            } else if (response['message'] != null) {
              errorMessage = response[
                  'message']; // Ambil pesan message dari response jika ada
            }
            // error = errorMessage; // Set error dengan pesan yang lebih spesifik
            // materialName = null; // Reset data jika terjadi error
            // syllabus = null;
            // price = null;
          }
        } else {
          error =
              'Terjadi kesalahan saat menghubungi server'; // Tangani kasus response null
          materialName = null; // Reset data jika terjadi error
          syllabus = null;
          price = null;
        }
        isLoading = false;
      });
      // Ambil daftar voucher
      final voucherResponse = await _paymentProvider.getVoucher();
      print("📌 Response API getVoucher: $voucherResponse");
      if (voucherResponse != null &&
          (voucherResponse['code'] == 200 || voucherResponse['code'] == 201) &&
          voucherResponse['data'] is List) {
        setState(() {
          voucherList
              .addAll(List<Map<String, dynamic>>.from(voucherResponse['data']));
        });
      } else {
        print("⚠️ Gagal memuat voucher, periksa respons API!");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  int calculateFinalPrice() {
    if (selectedVoucher == null || price == null) return price ?? 0;

    final selectedVoucherData = voucherList.firstWhere(
      (voucher) => voucher['ID'] == selectedVoucher,
      orElse: () => {'piece': 0},
    );

    final discount = (selectedVoucherData['piece'] as num?)?.toInt() ?? 0;
    return price! - (price! * discount ~/ 100);
  }

  Future<void> _processPayment() async {
    Map<String, dynamic> paymentData = {};
    if (selectedVoucher != null) {
      paymentData['ID'] = selectedVoucher;
    } else if (selectedVoucher == null) {
      paymentData['ID'] = selectedVoucher;
    }

    if (price == null) return;
    print("📦 Payment data yang dikirim: $paymentData");

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await _paymentProvider.processPayment(widget.projectId, paymentData);
      print("📌 Request Body voucher yang dikirim: $paymentData");
      print("📌 Request Body project yang dikirim: ${widget.projectId}");
      print("📌 Response API: $response");
      print("📌 Nilai selectedVoucher sebelum pembayaran: $selectedVoucher");
      if (response != null &&
          response['code'] == 201 &&
          response['data'] != null) {
        final String redirectUrl = response['data']['redirect_url'];
        print("📌 Redirect URL: $redirectUrl");

        // **Pindahkan ke halaman WaitingPayment sebelum membuka URL**
        print(
            "🚀 Navigating to WaitingPaymentScreen with ID: ${widget.projectId}");

        final String transactionId = response['data']['transactionID'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingPaymentScreen(
              transactionId: transactionId,
            ),
          ),
        );

        final Uri uri = Uri.parse(redirectUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal membuka halaman pembayaran')),
          );
        }
      } else {
        print("⚠️ Gagal memproses pembayaran, periksa respons API!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response?['error'] ?? 'Pembayaran gagal')),
        );
      }
    } catch (e) {
      print("⚠️ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xffE0FFF3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Rincian',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildLoadingState(),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xffE0FFF3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Rincian',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Oops, Terjadi Kesalahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadPaymentDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff339989),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffE0FFF3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rincian',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OptimizedFadeSlide(
                delay: Duration(milliseconds: 100),
                child: Text(
                  materialName ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              OptimizedFadeSlide(
                delay: Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.book,
                        '${syllabus}x Pertemuan',
                        const Color(0xff339989),
                      ),
                      const SizedBox(height: 15),
                      _buildDetailItem(
                        Icons.people,
                        'Konsultasi Online Gratis',
                        const Color(0xff339989),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Harga',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${price ?? 0},00',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff339989),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              OptimizedFadeSlide(
                delay: Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.confirmation_number_outlined,
                            color: Color(0xff339989),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pilih Voucher',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedVoucher ?? null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          hintText: 'Pilih voucher',
                          hintStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value:
                                null, // Opsi default yang bertindak sebagai hint
                            child: Text('Pilih voucher',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          ...voucherList.map((voucher) {
                            return DropdownMenuItem<String>(
                              value: voucher['ID'],
                              child: Text(
                                  '${voucher['name']} - Diskon ${voucher['piece']}%'),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedVoucher = value;
                          });
                        },
                      ),
                      if (selectedVoucher != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Harga Setelah Diskon',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Rp ${calculateFinalPrice()},00',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff339989),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OptimizedFadeSlide(
        delay: Duration(milliseconds: 400),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              final finalPrice = calculateFinalPrice();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Memproses pembayaran: Rp $finalPrice,00'),
                ),
              );
              _processPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff339989),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Bayar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerText(width: 250, height: 24),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    ShimmerText(width: 150, height: 16),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    ShimmerText(width: 180, height: 16),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerText(width: 100, height: 18),
                    ShimmerText(width: 120, height: 18),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerCircle(radius: 10),
                    const SizedBox(width: 8),
                    ShimmerText(width: 100, height: 14),
                  ],
                ),
                const SizedBox(height: 8),
                ShimmerText(width: double.infinity, height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

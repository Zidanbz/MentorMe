import 'package:flutter/material.dart';
import 'package:mentorme/providers/payment_provider.dart';
import 'package:mentorme/shared/widgets/enhanced_animations.dart' as enhanced;
import 'package:mentorme/shared/widgets/app_background.dart';
import 'package:mentorme/global/Fontstyle.dart';

class VoucherCodeClaimPage extends StatefulWidget {
  const VoucherCodeClaimPage({super.key});

  @override
  State<VoucherCodeClaimPage> createState() => _VoucherCodeClaimPageState();
}

class _VoucherCodeClaimPageState extends State<VoucherCodeClaimPage>
    with TickerProviderStateMixin {
  final PaymentProvider _paymentProvider = PaymentProvider();
  final TextEditingController _voucherCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  late AnimationController _backgroundController;
  late AnimationController _floatingController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatingController.dispose();
    _voucherCodeController.dispose();
    super.dispose();
  }

  Future<void> _claimVoucherByCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await _paymentProvider
          .claimVoucherByCode(_voucherCodeController.text.trim());

      if (result['success'] == true) {
        setState(() {
          _successMessage = 'Voucher berhasil diklaim!';
          _voucherCodeController.clear();
        });

        // Show success dialog
        _showSuccessDialog(result['data']);
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Gagal mengklaim voucher';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(Map<String, dynamic>? voucherData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFe0fff3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF339989), Color(0xFF3c493f)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Berhasil!',
              style: AppTextStyles.headlineSmall.copyWith(
                color: const Color(0xFF3c493f),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voucher berhasil diklaim!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF3c493f),
              ),
            ),
            if (voucherData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucherData['name'] ?? 'Voucher',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: const Color(0xFF3c493f),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Diskon: ${voucherData['piece'] ?? 0}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF339989),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (voucherData['info'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        voucherData['info'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF3c493f).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF339989), Color(0xFF3c493f)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Stack(
          children: [
            _buildFloatingElements(),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: 100 + _floatingAnimation.value,
              right: 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFe0fff3).withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              top: 200 - _floatingAnimation.value,
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF339989).withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 150 + _floatingAnimation.value,
              right: 50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3c493f).withOpacity(0.1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return enhanced.OptimizedFadeSlide(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            enhanced.OptimizedHover(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Klaim Voucher',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 300),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInstructionCard(),
            const SizedBox(height: 24),
            _buildVoucherCodeInput(),
            const SizedBox(height: 24),
            _buildClaimButton(),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(),
            ],
            if (_successMessage != null) ...[
              const SizedBox(height: 16),
              _buildSuccessMessage(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return enhanced.OptimizedScale(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF339989), Color(0xFF3c493f)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.redeem,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Masukkan Kode Voucher',
              style: AppTextStyles.headlineMedium.copyWith(
                color: const Color(0xFF3c493f),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan kode voucher yang Anda terima untuk mengklaim diskon khusus',
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF3c493f).withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCodeInput() {
    return enhanced.OptimizedFadeSlide(
      delay: const Duration(milliseconds: 400),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: _voucherCodeController,
          decoration: InputDecoration(
            labelText: 'Kode Voucher',
            hintText: 'Contoh: SAVE2024',
            prefixIcon: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF339989), Color(0xFF3c493f)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.confirmation_number,
                color: Colors.white,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            labelStyle: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF3c493f).withOpacity(0.7),
            ),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF3c493f).withOpacity(0.5),
            ),
          ),
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF3c493f),
            fontWeight: FontWeight.w600,
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Kode voucher tidak boleh kosong';
            }
            if (value.trim().length < 3) {
              return 'Kode voucher minimal 3 karakter';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildClaimButton() {
    return enhanced.OptimizedHover(
      scale: 1.02,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF339989), Color(0xFF3c493f)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF339989).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _isLoading ? null : _claimVoucherByCode,
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.redeem,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Klaim Voucher',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return enhanced.OptimizedFadeSlide(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.red.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return enhanced.OptimizedFadeSlide(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFe0fff3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF339989).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF339989),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _successMessage!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF3c493f),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_button.dart';
import '../../widgets/feature_icon.dart';

class PaymentQrPage extends StatefulWidget {
  const PaymentQrPage({super.key});
  @override
  State<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends State<PaymentQrPage> {
  bool _detected = false;
  bool _sheetShown = false;
  final _controller = MobileScannerController();

  // Mock merchant data for demo
  final _merchant = {
    'name': 'Kantin Teknik UI',
    'sub': 'NMID: ID2024088123 · QRIS',
    'amount': 27000.0
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_detected) {
      setState(() => _detected = true);
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: SafeArea(
        child: Stack(
          children: [
            // Camera
            MobileScanner(controller: _controller, onDetect: _onDetect),
            // Overlay
            _buildOverlay(),
            // Header
            _buildHeader(),
            // Detected sheet
            if (_detected && !_sheetShown) _buildDetectedSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.5),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/home'),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            Expanded(
              child: Text(
                'Scan QRIS',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: 38),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Viewfinder frame
          Stack(
            alignment: Alignment.center,
            children: [
              // Glass background
              Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1), width: 1),
                ),
              ),
              // Animated gradient guide frame
              _detected
                  ? Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.success,
                          width: 2.5,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              // Corner brackets
              ...[
                [0, 0],
                [1, 0],
                [0, 1],
                [1, 1]
              ].map((corner) => Positioned(
                    top: corner[1] == 0 ? 0 : null,
                    bottom: corner[1] == 1 ? 0 : null,
                    left: corner[0] == 0 ? 0 : null,
                    right: corner[0] == 1 ? 0 : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border(
                          top: corner[1] == 0
                              ? BorderSide(
                                  color: _detected
                                      ? AppColors.success
                                      : AppColors.secondary,
                                  width: 3.5)
                              : BorderSide.none,
                          bottom: corner[1] == 1
                              ? BorderSide(
                                  color: _detected
                                      ? AppColors.success
                                      : AppColors.secondary,
                                  width: 3.5)
                              : BorderSide.none,
                          left: corner[0] == 0
                              ? BorderSide(
                                  color: _detected
                                      ? AppColors.success
                                      : AppColors.secondary,
                                  width: 3.5)
                              : BorderSide.none,
                          right: corner[0] == 1
                              ? BorderSide(
                                  color: _detected
                                      ? AppColors.success
                                      : AppColors.secondary,
                                  width: 3.5)
                              : BorderSide.none,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: corner[0] == 0 && corner[1] == 0
                              ? const Radius.circular(8)
                              : Radius.zero,
                          topRight: corner[0] == 1 && corner[1] == 0
                              ? const Radius.circular(8)
                              : Radius.zero,
                          bottomLeft: corner[0] == 0 && corner[1] == 1
                              ? const Radius.circular(8)
                              : Radius.zero,
                          bottomRight: corner[0] == 1 && corner[1] == 1
                              ? const Radius.circular(8)
                              : Radius.zero,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _detected
                ? Row(
                    key: const ValueKey('detected'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.success, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Kode terdeteksi!',
                        style: GoogleFonts.inter(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Arahkan kamera ke kode QRIS',
                    key: const ValueKey('guide'),
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13.5,
                    ),
                  ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['Bayar', 'QR Saya'].map((label) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Icon(
                        label == 'Bayar'
                            ? Icons.qr_code_rounded
                            : Icons.qr_code_2_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedSheet() {
    final amount = _merchant['amount'] as double;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const FeatureIcon(
                      icon: Icons.storefront_rounded,
                      tone: 'purple',
                      size: 52,
                      iconSize: 26),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _merchant['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          _merchant['sub'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AppBadge(label: 'QRIS', tone: 'purple'),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Total tagihan',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.slate400),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(amount),
                style: GoogleFonts.inter(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'Bayar Sekarang',
                icon: const Icon(Icons.lock_rounded, size: 18, color: Colors.white),
                onPressed: () {
                  setState(() => _sheetShown = true);
                  context.go('/pin', extra: {
                    'kind': 'payment',
                    'description': 'Pembayaran ${_merchant['name']}',
                    'amount': amount,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/deeplink_callback_service.dart';
import '../../../core/services/deeplink_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

/// Halaman konfirmasi pembayaran yang dibuka dari deeplink merchant
/// (`techpay://pay?...` atau `https://techpay.app/pay?...`).
///
/// `data` bisa berupa:
///  - [DeeplinkPaymentData] → tampilkan ringkasan & tombol bayar
///  - [String]              → pesan error dari hasil parsing link
///  - `null`                → halaman dibuka tanpa data deeplink (link rusak)
class PaymentDeeplinkPage extends StatelessWidget {
  final Object? data;
  const PaymentDeeplinkPage({super.key, this.data});

  void _cancel(BuildContext context, DeeplinkPaymentData payload) {
    final cb = payload.callbackUrl;
    if (cb != null && cb.isNotEmpty) {
      DeeplinkCallbackService.notifyCancelled(
        callbackUrl: cb,
        reference: payload.reference,
      );
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final payload = data;

    if (payload is! DeeplinkPaymentData) {
      final message = payload is String
          ? payload
          : 'Link pembayaran tidak ditemukan atau tidak valid.';
      return _ErrorView(message: message);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _cancel(context, payload);
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Column(
          children: [
            // ─── Header ────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              padding: EdgeInsets.fromLTRB(
                  16, MediaQuery.of(context).padding.top + 6, 16, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _cancel(context, payload),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Konfirmasi Pembayaran',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.storefront_rounded,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          payload.merchantName,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Content ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  children: [
                    // Amount card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowCard,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CurrencyFormatter.format(payload.amount),
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                              letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Detail card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowCard,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Column(
                        children: [
                          _DetailRow(
                              label: 'Merchant', value: payload.merchantName),
                          Divider(height: 1, color: AppColors.line2),
                          _DetailRow(
                              label: 'Keterangan', value: payload.description),
                          if (payload.reference != null &&
                              payload.reference!.isNotEmpty) ...[
                            Divider(height: 1, color: AppColors.line2),
                            _DetailRow(
                                label: 'Referensi', value: payload.reference!),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Payment method
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 8),
                        child: Text(
                          'Metode pembayaran',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowCard,
                        border: Border.all(
                            color: AppColors.primaryBorder, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const AppLogo(size: 38),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TechPay',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  'Saldo · pembayaran instan',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.slate400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Security notice
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primarySurface,
                            AppColors.secondarySurface,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.primaryBorder.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(DkgIcons.shieldCheck,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pembayaran ini akan diverifikasi dengan PIN dan kode 2FA sesuai pengaturan keamanan akun kamu.',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Pay bar ───────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  16, 14, 16, MediaQuery.of(context).padding.bottom + 16),
              child: AppButton(
                label: 'Bayar ${CurrencyFormatter.format(payload.amount)}',
                onPressed: () => context.go('/pin', extra: {
                  'kind': 'deeplink',
                  'amount': payload.amount,
                  'description': payload.description,
                  'merchantName': payload.merchantName,
                  'merchantId': payload.merchantId,
                  'reference': payload.reference,
                  'callbackUrl': payload.callbackUrl,
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.slate500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.link_off_rounded,
                      size: 32, color: AppColors.error),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Link Tidak Valid',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColors.slate500, height: 1.5),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Kembali ke Beranda',
                fullWidth: false,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

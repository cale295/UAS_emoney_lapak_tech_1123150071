import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/feature_icon.dart';

class TransferConfirmPage extends StatelessWidget {
  final Map<String, dynamic> recipient;
  final String channel;
  final double amount;
  final String note;
  final double fee;

  const TransferConfirmPage({
    super.key,
    required this.recipient,
    required this.channel,
    required this.amount,
    required this.note,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    final total = amount + fee;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(
          title: 'Konfirmasi',
          onBack: () => context.go('/transfer/amount')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Recipient summary card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.shadowCard,
                    ),
                    child: Column(
                      children: [
                        channel == 'bank'
                            ? FeatureIcon(
                                icon: Icons.account_balance_rounded,
                                tone: 'blue',
                                size: 56,
                                iconSize: 28,
                              )
                            : AppAvatar(
                                name: recipient['name'] as String, size: 56),
                        const SizedBox(height: 12),
                        Text(
                          'Transfer ke',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.slate400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          channel == 'bank'
                              ? (recipient['sub'] as String)
                              : (recipient['name'] as String),
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          recipient['sub'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppColors.slate400),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          CurrencyFormatter.format(amount),
                          style: GoogleFonts.inter(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Detail rows
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.shadowCard,
                    ),
                    child: Column(
                      children: [
                        _Line(
                            label: 'Nominal',
                            value: CurrencyFormatter.format(amount)),
                        const Divider(height: 1, color: AppColors.line2),
                        _Line(
                            label: 'Biaya admin',
                            value: fee > 0
                                ? CurrencyFormatter.format(fee)
                                : 'Gratis'),
                        if (note.isNotEmpty) ...[
                          const Divider(height: 1, color: AppColors.line2),
                          _Line(label: 'Catatan', value: note),
                        ],
                        const Divider(height: 1, color: AppColors.line2),
                        _Line(
                            label: 'Total',
                            value: CurrencyFormatter.format(total),
                            bold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Source
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.shadowSoft,
                    ),
                    child: Row(
                      children: [
                        const AppLogo(size: 38),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo TechPay',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                'Sumber dana',
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
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16, 14, 16, MediaQuery.of(context).padding.bottom + 16),
            child: AppButton(
              label: 'Konfirmasi & Bayar',
              icon: const Icon(Icons.lock_rounded, size: 18, color: Colors.white),
              onPressed: () => context.go('/pin', extra: {
                'kind': 'transfer',
                'recipient': recipient,
                'channel': channel,
                'amount': amount,
                'note': note,
                'fee': fee,
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Line({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: bold ? 15 : 13.5,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: bold ? AppColors.ink : AppColors.slate500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: bold ? 15 : 13.5,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/feature_icon.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});
  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double _amount = 100000;
  String _method = 'bca';

  final _chips = [50000.0, 100000.0, 200000.0, 500000.0, 1000000.0];
  final _methods = [
    {
      'id': 'bca',
      'name': 'BCA Virtual Account',
      'tone': 'blue',
      'icon': Icons.account_balance_rounded
    },
    {
      'id': 'card',
      'name': 'Kartu Debit/Kredit',
      'tone': 'purple',
      'icon': Icons.credit_card_rounded
    },
    {
      'id': 'alfa',
      'name': 'Alfamart / Indomaret',
      'tone': 'red',
      'icon': Icons.storefront_rounded
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentTopupSuccess) {
          context.go('/success', extra: {
            'title': 'Top up berhasil',
            'subtitle': 'Saldo kamu bertambah',
            'amount': state.amount,
            'lines': [
              ['Metode', _methodName()],
              ['Saldo sekarang', CurrencyFormatter.format(state.balance)],
            ],
          });
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppTopBar(title: 'Isi Saldo', onBack: () => context.go('/home')),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Amount Label ─────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 12),
                      child: Text(
                        'Pilih nominal',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    // ─── Amount chips ─────────────────────────────
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: _chips.map((c) {
                        final selected = _amount == c;
                        return GestureDetector(
                          onTap: () => setState(() => _amount = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              gradient: selected
                                  ? AppColors.primaryGradient
                                  : null,
                              color: selected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? Colors.transparent
                                    : AppColors.line,
                                width: 1.5,
                              ),
                              boxShadow: selected
                                  ? AppColors.shadowPrimary
                                  : AppColors.shadowSoft,
                            ),
                            child: Center(
                              child: Text(
                                CurrencyFormatter.format(c),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.ink,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // ─── Payment methods ──────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 12),
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

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.shadowCard,
                      ),
                      child: Column(
                        children: _methods.asMap().entries.map((e) {
                          final i = e.key;
                          final m = e.value;
                          final isSelected = _method == m['id'];
                          return Column(
                            children: [
                              if (i > 0)
                                const Divider(
                                    height: 1, indent: 70, color: AppColors.line2),
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _method = m['id'] as String),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      FeatureIcon(
                                        icon: m['icon'] as IconData,
                                        tone: m['tone'] as String,
                                        size: 42,
                                        iconSize: 20,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          m['name'] as String,
                                          style: GoogleFonts.inter(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? AppColors.primaryGradient
                                              : null,
                                          color: isSelected ? null : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : AppColors.line,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check_rounded,
                                                size: 13, color: Colors.white)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── CTA Bar ─────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(
                  16, 14, 16, MediaQuery.of(context).padding.bottom + 16),
              child: BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, state) => AppButton(
                  label: 'Lanjut · ${CurrencyFormatter.format(_amount)}',
                  onPressed: () => context.go('/pin', extra: {
                    'kind': 'topup',
                    'amount': _amount,
                    'method': _method,
                  }),
                  isLoading: state is PaymentLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _methodName() =>
      (_methods.firstWhere((m) => m['id'] == _method)['name'] as String?) ?? '';
}

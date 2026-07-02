import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/account/account_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/num_pad.dart';

class TransferAmountPage extends StatefulWidget {
  final Map<String, dynamic> recipient;
  final String channel;

  const TransferAmountPage(
      {super.key, required this.recipient, required this.channel});

  @override
  State<TransferAmountPage> createState() => _TransferAmountPageState();
}

class _TransferAmountPageState extends State<TransferAmountPage> {
  int _amount = 0;
  String _note = '';

  final _chips = [20000, 50000, 100000, 250000];

  void _onKey(String k) {
    setState(() {
      if (k == 'del') {
        _amount = _amount ~/ 10;
      } else if (k == '000') {
        _amount = (_amount * 1000) > 100000000 ? _amount : _amount * 1000;
      } else {
        final n = _amount * 10 + int.parse(k);
        _amount = n > 100000000 ? _amount : n;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.select<AccountBloc, double>((b) {
      final s = b.state;
      return s is AccountLoaded ? s.account.balance : 0.0;
    });
    final fee = widget.channel == 'bank' ? 2500 : 0;
    final enough = _amount <= balance;
    final valid = _amount >= 1000 && enough;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppTopBar(
          title: 'Nominal Transfer',
          onBack: () => context.go('/transfer')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  // Recipient card
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.shadowSoft,
                    ),
                    child: Row(
                      children: [
                        widget.channel == 'bank'
                            ? FeatureIcon(
                                icon: Icons.account_balance_rounded,
                                tone: 'blue',
                                size: 42,
                                iconSize: 20,
                              )
                            : AppAvatar(
                                name: widget.recipient['name'] as String,
                                size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.channel == 'bank'
                                    ? (widget.recipient['sub'] as String)
                                    : (widget.recipient['name'] as String),
                                style: GoogleFonts.inter(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                widget.recipient['sub'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: AppColors.slate400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.verified_user_rounded,
                            size: 20, color: AppColors.success),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amount display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.shadowCard,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Nominal',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Rp ',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: _amount > 0
                                    ? AppColors.ink
                                    : AppColors.slate300,
                              ),
                            ),
                            Text(
                              _amount > 0
                                  ? _amount.toLocaleString()
                                  : '0',
                              style: GoogleFonts.inter(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: _amount > 0
                                    ? AppColors.ink
                                    : AppColors.slate300,
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          enough
                              ? 'Saldo: ${CurrencyFormatter.format(balance)}'
                              : 'Saldo tidak cukup',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color:
                                enough ? AppColors.slate400 : AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: _chips
                              .map((c) => GestureDetector(
                                    onTap: () =>
                                        setState(() => _amount = c),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: _amount == c
                                            ? AppColors.primarySurface
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _amount == c
                                              ? AppColors.primaryBorder
                                              : AppColors.line,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        CurrencyFormatter.formatInt(c),
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _amount == c
                                              ? AppColors.primary
                                              : AppColors.slate600,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppField(
                    value: _note,
                    onChanged: (v) => setState(() => _note = v),
                    placeholder: 'Tambah catatan (opsional)',
                    prefixIcon: const Icon(Icons.receipt_outlined, size: 20),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: NumPad(onKey: _onKey),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16, 14, 16, MediaQuery.of(context).padding.bottom + 16),
            child: AppButton(
              label: 'Lanjut',
              onPressed: valid
                  ? () => context.go('/transfer/confirm', extra: {
                        'recipient': widget.recipient,
                        'channel': widget.channel,
                        'amount': _amount.toDouble(),
                        'note': _note,
                        'fee': fee.toDouble(),
                      })
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

extension on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

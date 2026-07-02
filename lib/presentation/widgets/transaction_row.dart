import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction_entity.dart';
import 'feature_icon.dart';

class TransactionRow extends StatelessWidget {
  final TransactionEntity txn;
  final bool divider;

  const TransactionRow({super.key, required this.txn, this.divider = false});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isCredit;
    final (icon, tone) = _resolveIcon(txn.description);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (divider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.line2,
            indent: 72,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              FeatureIcon(icon: icon, tone: tone, size: 46, iconSize: 22),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(txn.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.slate400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isCredit ? '+' : '-'}${CurrencyFormatter.format(txn.amount)}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isCredit ? AppColors.success : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  _StatusChip(isCredit: isCredit),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  (IconData, String) _resolveIcon(String desc) {
    final d = desc.toLowerCase();
    if (d.contains('top up') || d.contains('topup')) return (DkgIcons.topup, 'blue');
    if (d.contains('transfer')) return (DkgIcons.send, 'green');
    if (d.contains('qris') || d.contains('bayar')) return (DkgIcons.qris, 'purple');
    if (d.contains('pulsa')) return (DkgIcons.pulsa, 'cyan');
    if (d.contains('tokobel') || d.contains('toko')) return (DkgIcons.store, 'amber');
    if (d.contains('tarik') || d.contains('withdraw')) return (DkgIcons.withdraw, 'red');
    return (DkgIcons.wallet, 'slate');
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);
    final time = '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
    if (date == today) return 'Hari ini, $time';
    if (date == yesterday) return 'Kemarin, $time';
    return '${dt.day} ${_month(dt.month)}, $time';
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[m - 1];
  }
}

class _StatusChip extends StatelessWidget {
  final bool isCredit;
  const _StatusChip({required this.isCredit});

  @override
  Widget build(BuildContext context) {
    final color = isCredit ? AppColors.success : AppColors.slate500;
    final bg = isCredit ? AppColors.successSurface : AppColors.line2;
    final label = isCredit ? 'Masuk' : 'Keluar';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

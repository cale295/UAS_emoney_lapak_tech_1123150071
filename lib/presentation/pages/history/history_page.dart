import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../blocs/account/account_bloc.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/transaction_row.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _tab = 'all';

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // ─── Header ──────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).padding.top + 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semua aktivitas transaksi kamu',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.slate400,
                  ),
                ),
                const SizedBox(height: 16),
                // Filter tabs
                Row(
                  children: [
                    ['all', 'Semua'],
                    ['out', 'Pengeluaran'],
                    ['in', 'Pemasukan']
                  ]
                      .map((t) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => setState(() => _tab = t[0]),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: _tab == t[0]
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: _tab == t[0] ? null : AppColors.bg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  t[1],
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _tab == t[0]
                                        ? Colors.white
                                        : AppColors.slate500,
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: AppColors.line),
              ],
            ),
          ),

          // ─── Content ─────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountLoading) {
                  return _buildSkeleton();
                }
                if (state is AccountError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.inter(color: AppColors.slate400),
                    ),
                  );
                }
                if (state is AccountLoaded) {
                  List<TransactionEntity> txns = state.transactions;
                  if (_tab == 'in') {
                    txns = txns.where((t) => t.isCredit).toList();
                  }
                  if (_tab == 'out') {
                    txns = txns.where((t) => !t.isCredit).toList();
                  }

                  if (txns.isEmpty) {
                    return _buildEmpty();
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 10),
                        child: Text(
                          'Hari ini',
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
                          children: txns
                              .asMap()
                              .entries
                              .map((e) =>
                                  TransactionRow(txn: e.value, divider: e.key > 0))
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.line2,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 12, color: AppColors.line2, width: 140),
                    const SizedBox(height: 6),
                    Container(
                        height: 10, color: AppColors.line2, width: 80),
                  ],
                ),
              ),
              Container(height: 14, width: 70, color: AppColors.line2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(DkgIcons.history,
                size: 36, color: AppColors.slate300),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada transaksi',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Transaksi kamu akan muncul di sini',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.slate400,
            ),
          ),
        ],
      ),
    );
  }
}

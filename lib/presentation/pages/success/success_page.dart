import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/success_check.dart';

class SuccessPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final double amount;
  final List<List<String>> lines;

  const SuccessPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.lines,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    // Refresh account data after successful transaction
    context.read<AuthBloc>().add(AuthCheckRequested());

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    // Delay content fade until success animation starts
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _fadeCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  children: [
                    const Spacer(),

                    // ─── Success animation ────────────────────────────
                    const SuccessCheck(size: 96),
                    const SizedBox(height: 28),

                    FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: Column(
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -0.4,
                              ),
                            ),
                            if (widget.subtitle.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.subtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14.5,
                                  color: AppColors.slate500,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Text(
                              CurrencyFormatter.format(widget.amount),
                              style: GoogleFonts.inter(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                letterSpacing: -1.0,
                              ),
                            ),
                            if (widget.lines.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: widget.lines.asMap().entries.map((e) {
                                    final i = e.key;
                                    final l = e.value;
                                    return Column(
                                      children: [
                                        if (i > 0)
                                          const Divider(
                                              height: 1, color: AppColors.line),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                l[0],
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.5,
                                                  color: AppColors.slate500,
                                                ),
                                              ),
                                              Text(
                                                l[1],
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.ink,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),

            // ─── CTA buttons ──────────────────────────────────────────
            FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
                child: Column(
                  children: [
                    AppButton(
                      label: 'Selesai',
                      onPressed: () => context.go('/home'),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: 'Bagikan bukti transaksi',
                      variant: AppButtonVariant.soft,
                      icon: const Icon(DkgIcons.copy,
                          size: 18, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

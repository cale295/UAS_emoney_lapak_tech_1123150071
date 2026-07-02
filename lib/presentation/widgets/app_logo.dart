import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool light;
  final bool withText;

  const AppLogo({super.key, this.size = 56, this.light = false, this.withText = false});

  @override
  Widget build(BuildContext context) {
    Widget icon = _LogoMark(size: size, light: light);

    if (!withText) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TechPay',
              style: GoogleFonts.inter(
                fontSize: size * 0.30,
                fontWeight: FontWeight.w700,
                color: light ? Colors.white : AppColors.ink,
                letterSpacing: -0.4,
                height: 1.05,
              ),
            ),
            Text(
              'Digital Wallet',
              style: GoogleFonts.inter(
                fontSize: size * 0.18,
                fontWeight: FontWeight.w500,
                color: light
                    ? Colors.white.withValues(alpha: 0.7)
                    : AppColors.slate400,
                letterSpacing: 0.5,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  final double size;
  final bool light;

  const _LogoMark({required this.size, required this.light});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: light
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFEFF6FF)],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: light
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Center(
        child: Text(
          'T',
          style: GoogleFonts.inter(
            fontSize: size * 0.52,
            fontWeight: FontWeight.w800,
            color: light ? AppColors.primary : Colors.white,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

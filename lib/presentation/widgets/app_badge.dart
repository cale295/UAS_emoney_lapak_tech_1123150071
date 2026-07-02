import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final String tone;

  const AppBadge({super.key, required this.label, this.tone = 'blue'});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.tone(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[0],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors[1].withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: colors[1],
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

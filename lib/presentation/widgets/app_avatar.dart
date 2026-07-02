import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart'; // needed for shadow colors

class AppAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? bg;
  final String? imageUrl;

  const AppAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.bg,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const gradients = [
      [Color(0xFF2563EB), Color(0xFF06B6D4)], // Blue → Cyan
      [Color(0xFF10B981), Color(0xFF06B6D4)], // Green → Cyan
      [Color(0xFF7C3AED), Color(0xFF2563EB)], // Purple → Blue
      [Color(0xFFF59E0B), Color(0xFFEF4444)], // Amber → Red
      [Color(0xFF06B6D4), Color(0xFF4F46E5)], // Cyan → Indigo
      [Color(0xFF10B981), Color(0xFF2563EB)], // Green → Blue
    ];
    final idx = (name.isNotEmpty ? name.codeUnitAt(0) : 0) % gradients.length;
    final gradient = gradients[idx];
    final initials = name
        .split(' ')
        .take(2)
        .map((s) => s.isNotEmpty ? s[0].toUpperCase() : '')
        .join();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: bg != null
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (bg ?? gradient.first).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? Image.network(imageUrl!, fit: BoxFit.cover)
          : Center(
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  // ─── Primary Blue ──────────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primarySurface = Color(0xFFEFF6FF);
  static const Color primaryBorder = Color(0xFFBFDBFE);

  // ─── Secondary Cyan ───────────────────────────────────────────
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);
  static const Color secondarySurface = Color(0xFFECFEFF);

  // ─── Accent Purple ────────────────────────────────────────────
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFF8B5CF6);
  static const Color accentSurface = Color(0xFFF5F3FF);

  // ─── Semantic ─────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successSurface = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEF2F2);

  // Keep backward compat aliases
  static const Color green = success;
  static const Color greenSurface = successSurface;
  static const Color amber = warning;
  static const Color amberSurface = warningSurface;
  static const Color red = error;
  static const Color redSurface = errorSurface;
  static const Color violet = accent;
  static const Color violetSurface = accentSurface;

  // ─── Neutral Slate ────────────────────────────────────────────
  static const Color ink = Color(0xFF0F172A);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color line = Color(0xFFE2E8F0);
  static const Color line2 = Color(0xFFF1F5F9);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // ─── Gradients ────────────────────────────────────────────────

  /// Blue → Cyan (primary action gradient)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
  );

  /// Blue → Purple (accent gradient)
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
  );

  /// Cyan → Indigo (secondary gradient)
  static const LinearGradient cyanIndigoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF4F46E5)],
  );

  /// Dark wallet card gradient
  static const LinearGradient walletGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0891B2)],
  );

  /// Splash background gradient (dark futuristic)
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0F172A)],
  );

  // ─── Shadows ──────────────────────────────────────────────────
  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
      blurRadius: 32,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
      blurRadius: 16,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowGlow = [
    BoxShadow(
      color: const Color(0xFF2563EB).withValues(alpha: 0.2),
      blurRadius: 40,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> shadowWallet = [
    BoxShadow(
      color: const Color(0xFF1E3A8A).withValues(alpha: 0.45),
      blurRadius: 40,
      spreadRadius: 0,
      offset: const Offset(0, 16),
    ),
  ];

  // ─── Tone map ─────────────────────────────────────────────────
  static const Map<String, List<Color>> tones = {
    'blue': [primarySurface, primary],
    'cyan': [secondarySurface, secondary],
    'purple': [accentSurface, accent],
    'green': [successSurface, success],
    'amber': [warningSurface, warning],
    'red': [errorSurface, error],
    'violet': [accentSurface, accent],
    'slate': [line2, slate600],
  };

  static List<Color> tone(String name) => tones[name] ?? tones['blue']!;
}
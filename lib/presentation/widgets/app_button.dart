import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

enum AppButtonVariant {
  primary,
  gradient,
  dark,
  soft,
  ghost,
  outline,
  outlineWhite,
  white,
  danger,
  success,
}

enum AppButtonSize { lg, md, sm }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;
  final Widget? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.fullWidth = true,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.onPressed == null || widget.isLoading) return;
    _ctrl.forward();
  }

  void _onTapUp(_) {
    _ctrl.reverse();
  }

  void _onTapCancel() {
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final (height, fontSize, radius, px) = switch (widget.size) {
      AppButtonSize.lg => (56.0, 16.0, 16.0, 20.0),
      AppButtonSize.md => (48.0, 15.0, 14.0, 16.0),
      AppButtonSize.sm => (38.0, 13.5, 12.0, 14.0),
    };

    final disabled = widget.onPressed == null;

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        child: child,
      ),
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: (disabled || widget.isLoading) ? null : widget.onPressed,
          child: _buildContent(height, fontSize, radius, px),
        ),
      ),
    );
  }

  Widget _buildContent(
      double height, double fontSize, double radius, double px) {
    final isGradientVariant = widget.variant == AppButtonVariant.primary ||
        widget.variant == AppButtonVariant.gradient;
    final (bg, fg, shadow, border, gradient) = _resolveStyle();

    return Container(
      height: height,
      width: widget.fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: px),
      decoration: BoxDecoration(
        gradient: isGradientVariant ? gradient : null,
        color: isGradientVariant ? null : bg,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
        border: border,
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isLoading) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(fg),
              ),
            ),
            const SizedBox(width: 10),
          ] else if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, List<BoxShadow>, Border?, LinearGradient) _resolveStyle() {
    return switch (widget.variant) {
      AppButtonVariant.primary || AppButtonVariant.gradient => (
          AppColors.primary,
          Colors.white,
          AppColors.shadowPrimary,
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.dark => (
          AppColors.ink,
          Colors.white,
          [],
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.soft => (
          AppColors.primarySurface,
          AppColors.primary,
          [],
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.ghost => (
          Colors.transparent,
          AppColors.slate600,
          [],
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.outline => (
          Colors.white,
          AppColors.ink,
          [],
          Border.all(color: AppColors.line, width: 1.5),
          AppColors.primaryGradient,
        ),
      AppButtonVariant.outlineWhite => (
          Colors.transparent,
          Colors.white,
          [],
          Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
          AppColors.primaryGradient,
        ),
      AppButtonVariant.white => (
          Colors.white,
          AppColors.primary,
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.danger => (
          AppColors.error,
          Colors.white,
          [],
          null,
          AppColors.primaryGradient,
        ),
      AppButtonVariant.success => (
          AppColors.success,
          Colors.white,
          [],
          null,
          AppColors.primaryGradient,
        ),
    };
  }
}

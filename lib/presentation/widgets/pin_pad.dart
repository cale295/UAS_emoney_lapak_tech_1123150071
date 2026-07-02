import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class PinPad extends StatelessWidget {
  final String value;
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onComplete;

  const PinPad({
    super.key,
    required this.value,
    required this.onChanged,
    this.length = 6,
    this.onComplete,
  });

  void _press(String key) {
    String next;
    if (key == 'del') {
      next = value.isEmpty ? '' : value.substring(0, value.length - 1);
    } else {
      if (value.length >= length) return;
      next = value + key;
    }
    onChanged(next);
    if (next.length == length) {
      Future.delayed(const Duration(milliseconds: 140),
          () => onComplete?.call(next));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      'bio', '0', 'del'
    ];

    return Column(
      children: [
        // PIN dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(length, (i) {
            final filled = i < value.length;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: filled ? 16 : 14,
              height: filled ? 16 : 14,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: filled
                    ? AppColors.primaryGradient
                    : null,
                color: filled ? null : Colors.transparent,
                border: filled
                    ? null
                    : Border.all(color: AppColors.primaryBorder, width: 2),
                boxShadow: filled
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        // Keypad grid
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: keys.map((k) {
            if (k == 'bio') {
              return _KeyButton(
                onTap: () => onComplete?.call(value),
                child: const Icon(Icons.fingerprint_rounded,
                    size: 28, color: AppColors.primary),
              );
            }
            if (k == 'del') {
              return _KeyButton(
                onTap: () => _press('del'),
                child: const Icon(Icons.backspace_rounded,
                    size: 22, color: AppColors.slate600),
              );
            }
            return _KeyButton(
              onTap: () => _press(k),
              child: Text(
                k,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _KeyButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _KeyButton({required this.onTap, required this.child});

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale =
        Tween<double>(begin: 1.0, end: 0.92).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.shadowSoft,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

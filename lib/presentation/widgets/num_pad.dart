import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class NumPad extends StatelessWidget {
  final ValueChanged<String> onKey;

  const NumPad({super.key, required this.onKey});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', 'del'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      children: keys.map((k) {
        Widget child;
        if (k == 'del') {
          child = const Icon(Icons.backspace_rounded, size: 22, color: AppColors.slate600);
        } else {
          child = Text(
            k,
            style: GoogleFonts.inter(
              fontSize: k == '000' ? 18 : 22,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          );
        }
        return _NumKey(onTap: () => onKey(k), child: child);
      }).toList(),
    );
  }
}

class _NumKey extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _NumKey({required this.onTap, required this.child});

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 90));
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(_ctrl);
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.line2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

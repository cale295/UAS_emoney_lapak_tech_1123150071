import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class CodeInput extends StatefulWidget {
  final int length;
  final String value;
  final ValueChanged<String> onChanged;
  final bool autoFocus;
  final bool hasError;

  const CodeInput({
    super.key,
    this.length = 6,
    required this.value,
    required this.onChanged,
    this.autoFocus = true,
    this.hasError = false,
  });

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late final FocusNode _focusNode;
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ctrl = TextEditingController(text: widget.value);
    if (widget.autoFocus) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void didUpdateWidget(CodeInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const maxBoxSize = 52.0;
    const horizontalMargin = 5.0;

    return GestureDetector(
      onTap: () {
        if (_focusNode.hasFocus) {
          SystemChannels.textInput.invokeMethod('TextInput.show');
        } else {
          _focusNode.requestFocus();
        }
      },
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: 1,
              height: 1,
              child: TextField(
                controller: _ctrl,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                onChanged: widget.onChanged,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalMargin = horizontalMargin * 2 * widget.length;
              final available = constraints.maxWidth - totalMargin;
              final boxSize =
                  (available / widget.length).clamp(0.0, maxBoxSize);
              final boxHeight = boxSize > 44 ? 60.0 : boxSize + 12;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.length, (i) {
                  final filled = i < widget.value.length;
                  final active = i == widget.value.length;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: boxSize,
                    height: boxHeight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: horizontalMargin),
                    decoration: BoxDecoration(
                      color: widget.hasError
                          ? AppColors.errorSurface
                          : filled
                              ? AppColors.primarySurface
                              : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: widget.hasError
                            ? AppColors.error
                            : active
                                ? AppColors.primary
                                : filled
                                    ? AppColors.primaryBorder
                                    : AppColors.line,
                        width: active || widget.hasError ? 2.0 : 1.5,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                blurRadius: 0,
                                spreadRadius: 3,
                              ),
                            ]
                          : AppColors.shadowSoft,
                    ),
                    child: Center(
                      child: filled
                          ? Text(
                              widget.value[i],
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            )
                          : active
                              ? Container(
                                  width: 2,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                )
                              : null,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

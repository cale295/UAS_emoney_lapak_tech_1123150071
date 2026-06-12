import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
    static const String _font = 'PlusJakartaSans';

    static const TextStyle h1 = TextStyle(
        fontFamily: _font,
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        letterSpacing: -0.5,
    );
    static const TextStyle h2 = TextStyle(
        fontFamily: _font,
        fontSize: 25,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        letterSpacing: -0.4,
    );
    static const TextStyle h3 = TextStyle(
        fontFamily: _font,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
        letterSpacing: -0.3,
    );
    static const TextStyle h4 = TextStyle(
        fontFamily: _font,
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
    );
}
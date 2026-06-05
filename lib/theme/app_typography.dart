import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Large, high-contrast sans-serif typography.
/// Status text is huge (>= 48sp); body is >= 16sp with generous line height.
class AppTypography {
  AppTypography._();

  static TextStyle get _base =>
      GoogleFonts.plusJakartaSans(color: AppColors.onSurface, height: 1.3);

  /// Hero status text — "ZONA BAHAYA" etc. (>= 48sp)
  static TextStyle get status => _base.copyWith(
        fontSize: 52,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -0.5,
      );

  static TextStyle get displayLarge =>
      _base.copyWith(fontSize: 34, fontWeight: FontWeight.w800, height: 1.1);

  static TextStyle get headline =>
      _base.copyWith(fontSize: 26, fontWeight: FontWeight.w700, height: 1.15);

  static TextStyle get title =>
      _base.copyWith(fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle get subtitle => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceMuted,
      );

  static TextStyle get body =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 1.45);

  static TextStyle get bodyMuted => body.copyWith(
        color: AppColors.onSurfaceMuted,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get label =>
      _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600);

  static TextStyle get caption => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceMuted,
      );

  static TextStyle get button =>
      _base.copyWith(fontSize: 18, fontWeight: FontWeight.w700);

  static TextTheme textTheme(TextTheme base) => base.copyWith(
        displayLarge: displayLarge,
        headlineMedium: headline,
        titleLarge: title,
        titleMedium: subtitle,
        bodyLarge: body,
        bodyMedium: bodyMuted,
        labelLarge: label,
      );
}

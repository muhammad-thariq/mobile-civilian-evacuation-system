import 'package:flutter/material.dart';

/// Single source of truth for SIAGA colors.
/// Color = meaning. Traffic-light semantics are consistent app-wide.
class AppColors {
  AppColors._();

  // Status / traffic-light semantics.
  static const Color danger = Color(0xFFD32F2F); // red zone
  static const Color caution = Color(0xFFF9A825); // amber zone
  static const Color safe = Color(0xFF2E7D32); // green zone & "I'm safe"

  // Official / trust accent.
  static const Color navy = Color(0xFF1E3A5F);

  // Neutrals.
  static const Color surface = Color(0xFFFAFAFA);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);

  // Derived shades used for fills, borders, muted text.
  static const Color onSurfaceMuted = Color(0xFF5F6368);
  static const Color border = Color(0xFFE2E4E8);
  static const Color cardSurface = Color(0xFFFFFFFF);

  // Soft tints for zone fills / banners backgrounds.
  static const Color dangerTint = Color(0x1AD32F2F);
  static const Color cautionTint = Color(0x1AF9A825);
  static const Color safeTint = Color(0x1A2E7D32);
  static const Color navyTint = Color(0x141E3A5F);
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';

/// Full-width hero banner. Enum-driven: color, label, and icon all change
/// together based on [StatusLevel].
class StatusBanner extends StatelessWidget {
  final StatusLevel level;
  const StatusBanner({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(level);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [style.color, Color.lerp(style.color, Colors.black, 0.18)!],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius + 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Icon(style.icon, color: AppColors.white, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Status lokasimu',
                style: AppTypography.label.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Status text >= 48sp, enum-driven.
          Text(
            style.label,
            style: AppTypography.status.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            style.description,
            style: AppTypography.body.copyWith(
              color: AppColors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }
}

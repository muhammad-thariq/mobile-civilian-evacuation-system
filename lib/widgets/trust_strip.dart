import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Navy "official source" trust strip, e.g.
/// "Sumber: BMKG • Diperbarui 2 menit lalu".
class TrustStrip extends StatelessWidget {
  final String source;
  final String updated;
  const TrustStrip({
    super.key,
    this.source = 'BMKG',
    this.updated = '2 menit lalu',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded,
              color: AppColors.white, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Sumber: $source',
                    style: AppTypography.label.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  TextSpan(
                    text: '  •  Diperbarui $updated',
                    style: AppTypography.label.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

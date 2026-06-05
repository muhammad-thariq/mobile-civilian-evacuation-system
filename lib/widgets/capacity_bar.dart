import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shelter occupancy bar. Color shifts from safe → caution → danger as it fills.
class CapacityBar extends StatelessWidget {
  final int used;
  final int total;
  const CapacityBar({super.key, required this.used, required this.total});

  Color get _color {
    final ratio = total == 0 ? 0.0 : used / total;
    if (ratio >= 0.9) return AppColors.danger;
    if (ratio >= 0.7) return AppColors.caution;
    return AppColors.safe;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (used / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Kapasitas', style: AppTypography.caption),
            Text('$used / $total orang',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _color,
                )),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
      ],
    );
  }
}

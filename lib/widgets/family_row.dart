import 'package:flutter/material.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'status_pill.dart';

/// One family member row: avatar, name/relation, status pill, last seen,
/// distance, and a "Hubungi" (call) action.
class FamilyRow extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onCall;
  const FamilyRow({super.key, required this.member, this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.navyTint,
            child: Text(
              member.name.substring(0, 1),
              style: AppTypography.title.copyWith(color: AppColors.navy),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(member.name,
                          style: AppTypography.title,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusPill(level: member.status),
                  ],
                ),
                const SizedBox(height: 2),
                Text('${member.relation} • ${member.distance}',
                    style: AppTypography.caption,
                    overflow: TextOverflow.ellipsis),
                Text('Terakhir terlihat ${member.lastSeen}',
                    style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton.filledTonal(
            onPressed: onCall,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.navyTint,
              foregroundColor: AppColors.navy,
              minimumSize: const Size(48, 48),
            ),
            icon: const Icon(Icons.call_rounded),
            tooltip: 'Hubungi',
          ),
        ],
      ),
    );
  }
}

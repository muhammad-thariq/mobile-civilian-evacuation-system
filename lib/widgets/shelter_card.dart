import 'package:flutter/material.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'capacity_bar.dart';

/// Shelter summary card used in the map sheet and the shelter finder list.
class ShelterCard extends StatelessWidget {
  final Shelter shelter;
  final VoidCallback? onRoute;

  const ShelterCard({super.key, required this.shelter, this.onRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(
          color: shelter.recommended ? AppColors.safe : AppColors.border,
          width: shelter.recommended ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.safeTint,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(Icons.home_work_rounded,
                    color: AppColors.safe, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(shelter.name,
                              style: AppTypography.title,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (shelter.recommended) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _Badge(
                            label: 'Disarankan',
                            color: AppColors.safe,
                          ),
                        ],
                      ],
                    ),
                    Text(shelter.address, style: AppTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _MetaChip(
                  icon: Icons.directions_walk_rounded,
                  label: '${shelter.walkTime} jalan'),
              _MetaChip(
                  icon: Icons.near_me_rounded, label: shelter.distance),
              _StatusTag(
                isOpen: shelter.isOpen,
              ),
              if (shelter.isAccessible)
                const _MetaChip(
                    icon: Icons.accessible_rounded, label: 'Ramah disabilitas'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CapacityBar(used: shelter.capacityUsed, total: shelter.capacityTotal),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.tapTarget - 8,
            child: FilledButton.icon(
              onPressed: onRoute,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
              ),
              icon: const Icon(Icons.directions_rounded),
              label: Text('Rutekan',
                  style: AppTypography.button.copyWith(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceMuted),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final bool isOpen;
  const _StatusTag({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? AppColors.safe : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isOpen ? Icons.lock_open_rounded : Icons.lock_rounded,
              size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(isOpen ? 'Buka' : 'Penuh',
              style: AppTypography.caption.copyWith(
                  color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
      ),
      child: Text(label,
          style: AppTypography.caption.copyWith(
              color: AppColors.white, fontWeight: FontWeight.w700)),
    );
  }
}

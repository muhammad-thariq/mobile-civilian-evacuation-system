import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

/// Turn-by-turn directions list shown after tapping "Rutekan". Explains each
/// step of the evacuation route before starting live navigation (/route).
class DirectionsScreen extends StatelessWidget {
  const DirectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Petunjuk Arah', style: AppTypography.title)),
      body: Column(
        children: [
          // Destination + trip summary.
          Container(
            width: double.infinity,
            color: AppColors.navy,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                  child: const Icon(Icons.home_work_rounded,
                      color: AppColors.white, size: 26),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Masjid Al-Ikhlas',
                          style: AppTypography.title
                              .copyWith(color: AppColors.white)),
                      Text('8 menit • 600 m • jalan kaki',
                          style: AppTypography.body
                              .copyWith(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Steps list.
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Text('Langkah', style: AppTypography.headline),
                const SizedBox(height: AppSpacing.md),
                for (var i = 0; i < kRouteSteps.length; i++)
                  _StepTile(
                    step: kRouteSteps[i],
                    isLast: i == kRouteSteps.length - 1,
                  ),
              ],
            ),
          ),
          // Start live navigation.
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton.safe(
                label: 'Mulai navigasi',
                icon: Icons.navigation_rounded,
                onPressed: () => context.push('/route'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final RouteStep step;
  final bool isLast;
  const _StepTile({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isEndpoint = step.distance.isEmpty;
    final color = isEndpoint ? AppColors.safe : AppColors.navy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              child: Icon(step.icon, color: color, size: 28),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(step.instruction, style: AppTypography.title),
            ),
          ],
        ),
        // Connector with optional distance label (image-style).
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Row(
                children: [
                  if (step.distance.isNotEmpty) ...[
                    Text(step.distance, style: AppTypography.bodyMuted),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  const Expanded(child: Divider(height: 1)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

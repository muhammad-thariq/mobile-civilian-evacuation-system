import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';
import '../widgets/action_tile.dart';
import '../widgets/status_banner.dart';
import '../widgets/trust_strip.dart';

/// FR-2 — Danger Status Home (hero). Also renders the SAFE-state home when
/// the status notifier is StatusLevel.safe. Includes a dev chip to cycle states.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder<StatusLevel>(
          valueListenable: AppState.status,
          builder: (context, level, _) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPad,
                AppSpacing.md,
                AppSpacing.screenPad,
                AppSpacing.xl,
              ),
              children: [
                _Header(),
                const SizedBox(height: AppSpacing.lg),
                // Long-press the banner to cycle states for the demo.
                GestureDetector(
                  onLongPress: AppState.cycleStatus,
                  child: StatusBanner(level: level),
                ),
                const SizedBox(height: AppSpacing.md),
                const TrustStrip(),
                const SizedBox(height: AppSpacing.xl),
                Text('Tindakan cepat', style: AppTypography.title),
                const SizedBox(height: AppSpacing.md),
                ActionTile(
                  icon: Icons.route_rounded,
                  title: 'Lihat Rute Aman',
                  meta: '600 m • 8 menit ke shelter terdekat',
                  accent: AppColors.safe,
                  onTap: () => context.push('/directions'),
                ),
                const SizedBox(height: AppSpacing.md),
                ActionTile(
                  icon: Icons.checklist_rounded,
                  title: 'Apa yang harus saya lakukan?',
                  meta: 'Langkah pertama saat keadaan darurat',
                  accent: AppColors.caution,
                  onTap: () => context.push('/actions'),
                ),
                const SizedBox(height: AppSpacing.md),
                ActionTile(
                  icon: Icons.campaign_rounded,
                  title: 'Peringatan resmi terbaru',
                  meta: 'BMKG • Peringatan dini banjir',
                  accent: AppColors.navy,
                  onTap: () => context.push('/warning'),
                ),
                const SizedBox(height: AppSpacing.xl),
                _DevChip(level: level),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: const Icon(Icons.shield_rounded,
              color: AppColors.white, size: 24),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SIAGA', style: AppTypography.title),
            Text('Jakarta Pusat', style: AppTypography.caption),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings_outlined),
          iconSize: 28,
          tooltip: 'Pengaturan',
        ),
      ],
    );
  }
}

/// Dev-only control to cycle the three status states for the demo.
class _DevChip extends StatelessWidget {
  final StatusLevel level;
  const _DevChip({required this.level});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ActionChip(
        avatar: const Icon(Icons.bolt_rounded, size: 18),
        label: Text('Demo: ganti status (${StatusStyle.of(level).shortLabel})'),
        onPressed: AppState.cycleStatus,
        backgroundColor: AppColors.navyTint,
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';
import '../widgets/action_tile.dart';

/// Info hub — a small directory that keeps every remaining screen reachable
/// from the bottom nav (warning details, first actions, shelters, settings).
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final severity = SeverityStyle.of(kWarning.severity);
    return Scaffold(
      appBar: AppBar(
        title: Text('Info & Bantuan', style: AppTypography.headline),
        toolbarHeight: 64,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPad,
          AppSpacing.sm,
          AppSpacing.screenPad,
          AppSpacing.xl,
        ),
        children: [
          // Latest official warning highlight.
          Material(
            color: severity.color,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              onTap: () => context.push('/warning'),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Icon(severity.icon, color: AppColors.white, size: 32),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peringatan ${severity.label}',
                              style: AppTypography.title
                                  .copyWith(color: AppColors.white)),
                          Text(kWarning.title,
                              style: AppTypography.caption
                                  .copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.white),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Panduan', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          ActionTile(
            icon: Icons.campaign_rounded,
            title: 'Peringatan resmi',
            meta: 'Detail dari sumber tepercaya',
            accent: AppColors.danger,
            onTap: () => context.push('/warning'),
          ),
          const SizedBox(height: AppSpacing.md),
          ActionTile(
            icon: Icons.checklist_rounded,
            title: 'Langkah pertama',
            meta: 'Yang harus dilakukan saat darurat',
            accent: AppColors.caution,
            onTap: () => context.push('/actions'),
          ),
          const SizedBox(height: AppSpacing.md),
          ActionTile(
            icon: Icons.home_work_rounded,
            title: 'Daftar shelter',
            meta: 'Tempat evakuasi terdekat',
            accent: AppColors.safe,
            onTap: () => context.push('/shelters'),
          ),
          const SizedBox(height: AppSpacing.md),
          ActionTile(
            icon: Icons.settings_rounded,
            title: 'Pengaturan',
            meta: 'Offline, bahasa & aksesibilitas',
            accent: AppColors.navy,
            onTap: () => context.push('/settings'),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Emergency numbers.
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nomor darurat', style: AppTypography.title),
                const SizedBox(height: AppSpacing.md),
                _EmergencyRow(label: 'Darurat nasional', number: '112'),
                _EmergencyRow(label: 'BPBD DKI Jakarta', number: '164'),
                _EmergencyRow(label: 'Pemadam Kebakaran', number: '113'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyRow extends StatelessWidget {
  final String label;
  final String number;
  const _EmergencyRow({required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.call_rounded,
              size: 20, color: AppColors.danger),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.body)),
          Text(number,
              style: AppTypography.title.copyWith(color: AppColors.danger)),
        ],
      ),
    );
  }
}

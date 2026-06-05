import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';
import '../widgets/primary_button.dart';

/// FR-4 — Official Warning Details. Severity header colored by enum, bordered
/// trust card, plain-language summary, affected-area chips, action buttons.
class WarningDetailsScreen extends StatelessWidget {
  const WarningDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const warning = kWarning;
    final style = SeverityStyle.of(warning.severity);

    return Scaffold(
      appBar: AppBar(title: Text('Peringatan Resmi', style: AppTypography.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPad,
          AppSpacing.sm,
          AppSpacing.screenPad,
          AppSpacing.xl,
        ),
        children: [
          // Severity header, enum-colored.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(style.icon, color: AppColors.white, size: 30),
                    const SizedBox(width: AppSpacing.sm),
                    Text('STATUS ${style.label}',
                        style: AppTypography.title
                            .copyWith(color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(warning.title,
                    style: AppTypography.headline
                        .copyWith(color: AppColors.white)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Bordered trust card.
          _TrustCard(warning: warning),
          const SizedBox(height: AppSpacing.lg),
          Text('Ringkasan', style: AppTypography.title),
          const SizedBox(height: AppSpacing.sm),
          Text(warning.summary, style: AppTypography.body),
          const SizedBox(height: AppSpacing.lg),
          Text('Wilayah terdampak', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final area in warning.affectedAreas)
                Chip(
                  avatar: const Icon(Icons.place_rounded,
                      size: 18, color: AppColors.danger),
                  label: Text(area),
                  backgroundColor: AppColors.white,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Lihat tindakan',
            icon: Icons.checklist_rounded,
            color: AppColors.danger,
            onPressed: () => context.push('/actions'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Membagikan peringatan resmi…'))),
            icon: const Icon(Icons.share_rounded),
            label: const Text('Bagikan peringatan resmi'),
          ),
        ],
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  final OfficialWarning warning;
  const _TrustCard({required this.warning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navyTint,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.navy, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded,
                  color: AppColors.navy, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(warning.source,
                    style: AppTypography.title.copyWith(color: AppColors.navy)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.safe,
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded,
                        size: 14, color: AppColors.white),
                    const SizedBox(width: 2),
                    Text('Terverifikasi',
                        style: AppTypography.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          _InfoLine(
              icon: Icons.schedule_rounded,
              label: 'Diterbitkan',
              value: warning.issuedAt),
          const SizedBox(height: AppSpacing.sm),
          _InfoLine(
              icon: Icons.timelapse_rounded,
              label: 'Masa berlaku',
              value: warning.validUntil),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoLine(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onSurfaceMuted),
        const SizedBox(width: AppSpacing.sm),
        Text('$label: ', style: AppTypography.caption),
        Expanded(
          child: Text(value,
              style: AppTypography.label, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

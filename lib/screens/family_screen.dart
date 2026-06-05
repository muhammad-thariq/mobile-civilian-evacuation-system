import 'package:flutter/material.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';
import '../widgets/family_row.dart';

/// FR-8 — Family Safety Check-in. Personal "Saya Aman" card, summary, and
/// family rows with status pills. All local visual state only.
class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  bool _imSafe = false;
  bool _shareLocation = true;

  int get _safeCount =>
      kFamily.where((m) => m.status == StatusLevel.safe).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga', style: AppTypography.headline),
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
          _PersonalCard(
            imSafe: _imSafe,
            shareLocation: _shareLocation,
            onToggleSafe: () => setState(() => _imSafe = !_imSafe),
            onToggleShare: (v) => setState(() => _shareLocation = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SummaryRow(safe: _safeCount, total: kFamily.length),
          const SizedBox(height: AppSpacing.lg),
          Text('Anggota keluarga', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          for (final m in kFamily) ...[
            FamilyRow(
              member: m,
              onCall: () => _snack(context, 'Menghubungi ${m.name}…'),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _snack(context, 'Tambah anggota keluarga'),
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Tambah anggota keluarga'),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _PersonalCard extends StatelessWidget {
  final bool imSafe;
  final bool shareLocation;
  final VoidCallback onToggleSafe;
  final ValueChanged<bool> onToggleShare;

  const _PersonalCard({
    required this.imSafe,
    required this.shareLocation,
    required this.onToggleSafe,
    required this.onToggleShare,
  });

  @override
  Widget build(BuildContext context) {
    final color = imSafe ? AppColors.safe : AppColors.navy;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: imSafe ? AppColors.safeTint : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: imSafe ? AppColors.safe : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                imSafe
                    ? Icons.check_circle_rounded
                    : Icons.person_pin_circle_rounded,
                color: color,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  imSafe ? 'Kamu menandai diri AMAN' : 'Status kamu',
                  style: AppTypography.title.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.tapTarget,
            child: FilledButton.icon(
              onPressed: onToggleSafe,
              style: FilledButton.styleFrom(
                backgroundColor: imSafe ? AppColors.white : AppColors.safe,
                foregroundColor: imSafe ? AppColors.safe : AppColors.white,
                side: imSafe
                    ? const BorderSide(color: AppColors.safe, width: 1.5)
                    : null,
              ),
              icon: Icon(imSafe
                  ? Icons.refresh_rounded
                  : Icons.front_hand_rounded),
              label: Text(imSafe ? 'Batalkan status aman' : 'Saya Aman',
                  style: AppTypography.button.copyWith(
                      color: imSafe ? AppColors.safe : AppColors.white)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: shareLocation,
            onChanged: onToggleShare,
            activeThumbColor: AppColors.safe,
            title: Text('Bagikan lokasi ke keluarga',
                style: AppTypography.label),
            subtitle: Text('Keluarga bisa melihat posisimu',
                style: AppTypography.caption),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int safe;
  final int total;
  const _SummaryRow({required this.safe, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_rounded, color: AppColors.white, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$safe dari $total aman',
                    style: AppTypography.headline
                        .copyWith(color: AppColors.white)),
                Text('${total - safe} anggota perlu dipastikan',
                    style: AppTypography.caption
                        .copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

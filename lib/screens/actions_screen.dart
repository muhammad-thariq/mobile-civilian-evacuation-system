import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

/// FR-5 — First-Actions Checklist. Ordered cards; tapping toggles a local
/// checkmark via setState (visual only).
class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  final Set<int> _done = {};

  double get _progress =>
      kFirstActions.isEmpty ? 0 : _done.length / kFirstActions.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Langkah Pertama', style: AppTypography.title)),
      body: Column(
        children: [
          // "Lakukan sekarang" header + progress bar.
          Container(
            width: double.infinity,
            color: AppColors.dangerTint,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.danger),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Lakukan sekarang',
                        style: AppTypography.headline
                            .copyWith(color: AppColors.danger)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 10,
                    backgroundColor: AppColors.white,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.danger),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('${_done.length} dari ${kFirstActions.length} selesai',
                    style: AppTypography.caption),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: kFirstActions.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                final a = kFirstActions[i];
                final done = _done.contains(i);
                return _ChecklistCard(
                  number: i + 1,
                  action: a,
                  done: done,
                  onTap: () => setState(() {
                    done ? _done.remove(i) : _done.add(i);
                  }),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: PrimaryButton.safe(
                label: 'Mulai rute evakuasi',
                icon: Icons.directions_run_rounded,
                onPressed: () => context.push('/directions'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  final int number;
  final ChecklistAction action;
  final bool done;
  final VoidCallback onTap;

  const _ChecklistCard({
    required this.number,
    required this.action,
    required this.done,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: done ? AppColors.safeTint : AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(
                color: done ? AppColors.safe : AppColors.border,
                width: done ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: done ? AppColors.safe : AppColors.navy,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.white, size: 22)
                    : Text('$number',
                        style: AppTypography.title
                            .copyWith(color: AppColors.white)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action.action,
                        style: AppTypography.title.copyWith(
                          decoration:
                              done ? TextDecoration.lineThrough : null,
                          color: done
                              ? AppColors.onSurfaceMuted
                              : AppColors.onSurface,
                        )),
                    const SizedBox(height: 2),
                    Text(action.detail, style: AppTypography.caption),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(action.icon,
                  color: done ? AppColors.safe : AppColors.onSurfaceMuted),
            ],
          ),
        ),
      ),
    );
  }
}

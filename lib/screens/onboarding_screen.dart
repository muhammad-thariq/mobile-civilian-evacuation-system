import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';

/// FR-1 — Onboarding & Permission (visual only). The button just navigates
/// onward; no real permission request.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo + tagline.
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(AppSpacing.xl),
                ),
                child: const Icon(Icons.shield_rounded,
                    color: AppColors.white, size: 48),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('SIAGA', style: AppTypography.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Tahu bahaya, tahu jalan keluar',
                style: AppTypography.subtitle,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              // 3 value rows.
              const _ValueRow(
                icon: Icons.warning_amber_rounded,
                color: AppColors.danger,
                title: 'Peringatan dini resmi',
                subtitle: 'Langsung dari BMKG, BNPB & BPBD',
              ),
              const SizedBox(height: AppSpacing.lg),
              const _ValueRow(
                icon: Icons.route_rounded,
                color: AppColors.safe,
                title: 'Rute evakuasi aman',
                subtitle: 'Jalur tercepat ke shelter terdekat',
              ),
              const SizedBox(height: AppSpacing.lg),
              const _ValueRow(
                icon: Icons.groups_rounded,
                color: AppColors.navy,
                title: 'Pantau keluarga',
                subtitle: 'Pastikan semua orang tercinta aman',
              ),
              const Spacer(flex: 2),
              PrimaryButton.safe(
                label: 'Izinkan Akses Lokasi',
                icon: Icons.my_location_rounded,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/home'),
                child: Text('Pakai tanpa lokasi',
                    style: AppTypography.button.copyWith(
                      color: AppColors.navy,
                      decoration: TextDecoration.underline,
                    )),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 16, color: AppColors.onSurfaceMuted),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'Lokasimu hanya dipakai untuk memandu evakuasi.',
                      style: AppTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _ValueRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.title),
              Text(subtitle, style: AppTypography.caption),
            ],
          ),
        ),
      ],
    );
  }
}

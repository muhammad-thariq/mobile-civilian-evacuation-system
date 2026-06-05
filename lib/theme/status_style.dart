import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Overall danger level for the user's current location.
enum StatusLevel { safe, caution, danger }

/// Official warning severity (Indonesian BMKG/BNPB terminology).
enum Severity { waspada, siaga, awas }

/// Single source of truth: a status enum drives color, label, icon,
/// and tint everywhere in the app.
class StatusStyle {
  final Color color;
  final Color tint;
  final String label;
  final String shortLabel;
  final String description;
  final IconData icon;

  const StatusStyle({
    required this.color,
    required this.tint,
    required this.label,
    required this.shortLabel,
    required this.description,
    required this.icon,
  });

  static StatusStyle of(StatusLevel level) {
    switch (level) {
      case StatusLevel.danger:
        return const StatusStyle(
          color: AppColors.danger,
          tint: AppColors.dangerTint,
          label: 'ZONA BAHAYA',
          shortLabel: 'Bahaya',
          description: 'Segera evakuasi ke tempat aman terdekat.',
          icon: Icons.warning_amber_rounded,
        );
      case StatusLevel.caution:
        return const StatusStyle(
          color: AppColors.caution,
          tint: AppColors.cautionTint,
          label: 'WASPADA',
          shortLabel: 'Waspada',
          description: 'Bersiaga. Pantau perkembangan dan siapkan rute keluar.',
          icon: Icons.error_outline_rounded,
        );
      case StatusLevel.safe:
        return const StatusStyle(
          color: AppColors.safe,
          tint: AppColors.safeTint,
          label: 'AMAN',
          shortLabel: 'Aman',
          description: 'Tidak ada ancaman aktif di lokasimu saat ini.',
          icon: Icons.check_circle_outline_rounded,
        );
    }
  }
}

/// Style mapping for official warning severity.
class SeverityStyle {
  final Color color;
  final Color tint;
  final String label;
  final IconData icon;

  const SeverityStyle({
    required this.color,
    required this.tint,
    required this.label,
    required this.icon,
  });

  static SeverityStyle of(Severity severity) {
    switch (severity) {
      case Severity.awas:
        return const SeverityStyle(
          color: AppColors.danger,
          tint: AppColors.dangerTint,
          label: 'AWAS',
          icon: Icons.crisis_alert_rounded,
        );
      case Severity.siaga:
        return const SeverityStyle(
          color: AppColors.caution,
          tint: AppColors.cautionTint,
          label: 'SIAGA',
          icon: Icons.notification_important_rounded,
        );
      case Severity.waspada:
        return const SeverityStyle(
          color: AppColors.navy,
          tint: AppColors.navyTint,
          label: 'WASPADA',
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

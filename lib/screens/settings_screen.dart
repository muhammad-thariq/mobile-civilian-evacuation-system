import 'package:flutter/material.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// FR-9 — Settings / Offline & Trust (visual only). Toggles change appearance
/// only; nothing is persisted.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _location = true;
  bool _notifications = true;
  bool _largeText = false;
  bool _highContrast = false;
  bool _isIndonesian = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan', style: AppTypography.title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: 'Lokasi & Notifikasi',
            children: [
              _SwitchTile(
                icon: Icons.my_location_rounded,
                title: 'Akses lokasi',
                subtitle: 'Untuk memandu evakuasi',
                value: _location,
                onChanged: (v) => setState(() => _location = v),
              ),
              _SwitchTile(
                icon: Icons.notifications_active_rounded,
                title: 'Notifikasi peringatan dini',
                subtitle: 'Peringatan resmi BMKG & BNPB',
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
            ],
          ),
          _Section(
            title: 'Mode Offline',
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.navyTint,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.download_for_offline_rounded,
                        color: AppColors.navy, size: 32),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Unduh peta wilayahmu',
                              style: AppTypography.title),
                          Text('48 MB • Terakhir diperbarui kemarin',
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        minimumSize: const Size(0, 44),
                      ),
                      onPressed: () {},
                      child: const Text('Unduh'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _Section(
            title: 'Sumber Tepercaya',
            children: [
              for (final s in kTrustedSources)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_rounded,
                      color: AppColors.safe),
                  title: Text(s.name, style: AppTypography.title),
                  subtitle: Text(s.fullName, style: AppTypography.caption),
                  trailing: const Icon(Icons.check_circle_rounded,
                      color: AppColors.safe),
                ),
            ],
          ),
          _Section(
            title: 'Bahasa',
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Indonesia')),
                  ButtonSegment(value: false, label: Text('English')),
                ],
                selected: {_isIndonesian},
                onSelectionChanged: (s) =>
                    setState(() => _isIndonesian = s.first),
              ),
            ],
          ),
          _Section(
            title: 'Aksesibilitas',
            children: [
              _SwitchTile(
                icon: Icons.text_fields_rounded,
                title: 'Teks besar',
                subtitle: 'Perbesar ukuran tulisan',
                value: _largeText,
                onChanged: (v) => setState(() => _largeText = v),
              ),
              _SwitchTile(
                icon: Icons.contrast_rounded,
                title: 'Kontras tinggi',
                subtitle: 'Tingkatkan keterbacaan',
                value: _highContrast,
                onChanged: (v) => setState(() => _highContrast = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: AppTypography.subtitle),
        const SizedBox(height: AppSpacing.sm),
        ...children,
        const Divider(height: AppSpacing.xl),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.navy),
      activeThumbColor: AppColors.safe,
      value: value,
      onChanged: onChanged,
      title: Text(title, style: AppTypography.label),
      subtitle: Text(subtitle, style: AppTypography.caption),
    );
  }
}

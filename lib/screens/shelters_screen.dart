import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/shelter_card.dart';
import '../widgets/zone_map.dart';

/// FR-6 — Nearest-Shelter Finder. Map preview on top, scrollable list sorted
/// nearest-first, with visual filter chips.
class SheltersScreen extends StatefulWidget {
  const SheltersScreen({super.key});

  @override
  State<SheltersScreen> createState() => _SheltersScreenState();
}

class _SheltersScreenState extends State<SheltersScreen> {
  final Set<String> _filters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shelter Terdekat', style: AppTypography.title)),
      body: Column(
        children: [
          // Small map preview.
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ZoneMap(showZones: true, interactive: false),
                ),
                Positioned(
                  right: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: FloatingActionButton.small(
                    heroTag: 'open-map',
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.navy,
                    onPressed: () => context.go('/map'),
                    child: const Icon(Icons.open_in_full_rounded),
                  ),
                ),
              ],
            ),
          ),
          // Filter chips (visual toggle).
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                for (final f in const [
                  'Ramah disabilitas',
                  'Buka sekarang',
                  'Masih ada tempat',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(f),
                      selected: _filters.contains(f),
                      onSelected: (v) => setState(() {
                        v ? _filters.add(f) : _filters.remove(f);
                      }),
                      selectedColor: AppColors.navyTint,
                      checkmarkColor: AppColors.navy,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: kShelters.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) => ShelterCard(
                shelter: kShelters[i],
                onRoute: () => context.push('/directions'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

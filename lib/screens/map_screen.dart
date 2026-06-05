import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/status_style.dart';
import '../widgets/shelter_card.dart';
import '../widgets/zone_map.dart';

/// FR-3 — Danger-Zone Map. Visual-only flutter_map with zone polygons,
/// search field, layers toggle, legend, and a draggable shelter sheet.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _showZones = true;
  final bool _showShelters = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ZoneMap(
              showZones: _showZones,
              showShelters: _showShelters,
            ),
          ),
          // Top controls: search + layers toggle.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _SearchField()),
                      const SizedBox(width: AppSpacing.sm),
                      _MapButton(
                        icon: Icons.layers_rounded,
                        active: _showZones,
                        onTap: () =>
                            setState(() => _showZones = !_showZones),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _LegendCard(),
                  ),
                ],
              ),
            ),
          ),
          // Draggable bottom sheet with shelters.
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.14,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.xl),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 16),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.pillRadius),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Text('Shelter terdekat',
                            style: AppTypography.headline),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push('/shelters'),
                          child: const Text('Lihat semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    for (final s in kShelters) ...[
                      ShelterCard(
                        shelter: s,
                        onRoute: () => context.push('/directions'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.tapTarget,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: const TextField(
        enabled: false, // non-functional, styled only
        decoration: InputDecoration(
          hintText: 'Cari lokasi atau shelter…',
          prefixIcon: Icon(Icons.search_rounded),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _MapButton(
      {required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.navy : AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        child: SizedBox(
          width: AppSpacing.tapTarget,
          height: AppSpacing.tapTarget,
          child: Icon(icon,
              color: active ? AppColors.white : AppColors.onSurface),
        ),
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final level in StatusLevel.values) ...[
            _LegendDot(level: level),
            if (level != StatusLevel.values.last)
              const SizedBox(width: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final StatusLevel level;
  const _LegendDot({required this.level});

  @override
  Widget build(BuildContext context) {
    final style = StatusStyle.of(level);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: style.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(style.shortLabel, style: AppTypography.caption),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';
import '../widgets/zone_map.dart';

/// FR-7 — Safe-Route Navigation. Navy turn banner, map with green route
/// polyline + shaded red zones, and a bottom sheet with progress + actions.
///
/// Pressing "Mulai" animates the dummy current-location dot along the route
/// to the chosen shelter (camera follows, route fills in, progress updates).
class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )
      ..addListener(_onTick)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() {}); // refresh into the "arrived" state
        }
      });
  }

  void _onTick() {
    // Keep the camera centered on the moving dot for a navigation feel.
    _mapController.move(routePointAt(_ctrl.value), 16);
    setState(() {});
  }

  bool get _moving => _ctrl.isAnimating;
  bool get _arrived => _ctrl.value >= 1.0;

  void _togglePlay() {
    if (_moving) {
      _ctrl.stop();
    } else if (_arrived) {
      _ctrl.forward(from: 0); // restart the trip
    } else {
      _ctrl.forward();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _ctrl.value;
    final remainingMeters = (kRouteLengthMeters * (1 - t)).round();
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ZoneMap(
              showRoute: true,
              showShelters: true,
              mapController: _mapController,
              currentLocation: routePointAt(t),
              routeProgress: t,
            ),
          ),
          // Navy turn-instruction banner.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _TurnBanner(
                arrived: _arrived,
                remainingMeters: remainingMeters,
              ),
            ),
          ),
          // Back button.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, top: 96),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FloatingActionButton.small(
                  heroTag: 'route-back',
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.navy,
                  onPressed: () => context.pop(),
                  child: const Icon(Icons.arrow_back_rounded),
                ),
              ),
            ),
          ),
          _RouteSheet(
            progress: t,
            moving: _moving,
            arrived: _arrived,
            remainingMeters: remainingMeters,
            onPlayPause: _togglePlay,
            onSafe: () => _confirmSafe(context),
          ),
        ],
      ),
    );
  }

  void _confirmSafe(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.check_circle_rounded,
            color: AppColors.safe, size: 48),
        title: const Text('Kamu sudah aman'),
        content: const Text(
            'Status amanmu akan dibagikan ke keluarga. Tetap waspada dan '
            'ikuti arahan petugas.'),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.safe),
            onPressed: () {
              Navigator.pop(context);
              context.go('/family');
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}

class _TurnBanner extends StatelessWidget {
  final bool arrived;
  final int remainingMeters;
  const _TurnBanner({required this.arrived, required this.remainingMeters});

  @override
  Widget build(BuildContext context) {
    final color = arrived ? AppColors.safe : AppColors.navy;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Icon(
              arrived ? Icons.flag_rounded : Icons.turn_left_rounded,
              color: AppColors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arrived
                      ? 'Anda telah tiba di shelter'
                      : 'Belok kiri ke Jl. Merdeka',
                  style: AppTypography.title.copyWith(color: AppColors.white),
                ),
                Text(
                  arrived ? 'Masjid Al-Ikhlas' : 'Sisa $remainingMeters m',
                  style: AppTypography.body.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteSheet extends StatelessWidget {
  final double progress;
  final bool moving;
  final bool arrived;
  final int remainingMeters;
  final VoidCallback onPlayPause;
  final VoidCallback onSafe;

  const _RouteSheet({
    required this.progress,
    required this.moving,
    required this.arrived,
    required this.remainingMeters,
    required this.onPlayPause,
    required this.onSafe,
  });

  ({String label, IconData icon}) get _playButton {
    if (moving) return (label: 'Jeda', icon: Icons.pause_rounded);
    if (arrived) return (label: 'Ulangi', icon: Icons.replay_rounded);
    if (progress > 0) return (label: 'Lanjutkan', icon: Icons.play_arrow_rounded);
    return (label: 'Mulai', icon: Icons.play_arrow_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final play = _playButton;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16)],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.pillRadius),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.home_work_rounded,
                        color: AppColors.safe, size: 28),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Masjid Al-Ikhlas',
                              style: AppTypography.title),
                          Text(
                            arrived
                                ? 'Tiba • 600 m ditempuh'
                                : 'ETA ${((1 - progress) * 8).ceil()} menit • '
                                    'sisa $remainingMeters m',
                            style: AppTypography.bodyMuted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: AppColors.border,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.safe),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: AppSpacing.tapTarget,
                        child: FilledButton.icon(
                          onPressed: onPlayPause,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: AppColors.white,
                          ),
                          icon: Icon(play.icon),
                          label: Text(play.label,
                              style: AppTypography.button
                                  .copyWith(color: AppColors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    SizedBox(
                      height: AppSpacing.tapTarget,
                      child: OutlinedButton.icon(
                        onPressed: () => context.push('/shelters'),
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: const Text('Ganti'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Prominent "Saya sudah aman".
                PrimaryButton.safe(
                  label: 'Saya sudah aman',
                  icon: Icons.verified_rounded,
                  onPressed: onSafe,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/status_style.dart';

/// Visual-only map: OpenStreetMap tiles with hardcoded zone polygons,
/// a "current location" dot, shelter markers, and an optional route.
/// No live location, no routing engine — movement is faked by callers.
class ZoneMap extends StatelessWidget {
  final bool showZones;
  final bool showShelters;
  final bool showRoute;
  final double initialZoom;
  final bool interactive;

  /// Overrides the position of the current-location dot. Defaults to the
  /// static [kCurrentLocation]. Used to fake travel along the route.
  final LatLng? currentLocation;

  /// Fraction of the route already walked (0..1). Splits the route line into
  /// a dimmed "traveled" part and a bold green "remaining" part.
  final double routeProgress;

  /// Lets a caller drive the camera (e.g. follow the moving dot).
  final MapController? mapController;

  const ZoneMap({
    super.key,
    this.showZones = true,
    this.showShelters = true,
    this.showRoute = false,
    this.initialZoom = 15,
    this.interactive = true,
    this.currentLocation,
    this.routeProgress = 0,
    this.mapController,
  });

  Color _zoneColor(StatusLevel level) => StatusStyle.of(level).color;

  @override
  Widget build(BuildContext context) {
    final split = showRoute ? splitRouteAt(routeProgress) : null;
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: kMapCenter,
        initialZoom: initialZoom,
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.siaga.prototype',
        ),
        if (showZones)
          PolygonLayer(
            polygons: [
              for (final z in kZonePolygons)
                Polygon(
                  points: z.points,
                  color: _zoneColor(z.level).withValues(alpha: 0.28),
                  borderColor: _zoneColor(z.level),
                  borderStrokeWidth: 2,
                ),
            ],
          ),
        if (split != null)
          PolylineLayer(
            polylines: [
              // Already-walked portion, dimmed.
              Polyline(
                points: split.traveled,
                color: AppColors.navy.withValues(alpha: 0.35),
                strokeWidth: 6,
              ),
              // Remaining portion to the shelter, bold green.
              Polyline(
                points: split.remaining,
                color: AppColors.safe,
                strokeWidth: 7,
                borderColor: AppColors.white,
                borderStrokeWidth: 2,
              ),
            ],
          ),
        if (showShelters)
          MarkerLayer(
            markers: [
              for (final s in kShelters)
                Marker(
                  point: s.location,
                  width: 40,
                  height: 40,
                  child: _ShelterPin(recommended: s.recommended),
                ),
            ],
          ),
        // "Current location" dot (static, or faked-moving via currentLocation).
        MarkerLayer(
          markers: [
            Marker(
              point: currentLocation ?? kCurrentLocation,
              width: 28,
              height: 28,
              child: const _CurrentLocationDot(),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShelterPin extends StatelessWidget {
  final bool recommended;
  const _ShelterPin({required this.recommended});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.safe,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        recommended ? Icons.star_rounded : Icons.home_work_rounded,
        color: AppColors.white,
        size: 20,
      ),
    );
  }
}

class _CurrentLocationDot extends StatelessWidget {
  const _CurrentLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navy,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

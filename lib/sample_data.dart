import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'theme/status_style.dart';

/// All hardcoded mock content lives here so it's easy to tweak for the demo.
/// Coordinates are around Jakarta for visual realism only — no real GPS.

// ---------------------------------------------------------------------------
// Map geometry
// ---------------------------------------------------------------------------

/// Fake "current location" dot.
const LatLng kCurrentLocation = LatLng(-6.2088, 106.8456);

/// Default map camera.
const LatLng kMapCenter = LatLng(-6.2075, 106.8470);

class ZonePolygon {
  final StatusLevel level;
  final List<LatLng> points;
  const ZonePolygon(this.level, this.points);
}

const List<ZonePolygon> kZonePolygons = [
  ZonePolygon(StatusLevel.danger, [
    LatLng(-6.2120, 106.8400),
    LatLng(-6.2120, 106.8480),
    LatLng(-6.2060, 106.8490),
    LatLng(-6.2050, 106.8410),
  ]),
  ZonePolygon(StatusLevel.caution, [
    LatLng(-6.2050, 106.8410),
    LatLng(-6.2060, 106.8490),
    LatLng(-6.2010, 106.8500),
    LatLng(-6.2000, 106.8420),
  ]),
  ZonePolygon(StatusLevel.safe, [
    LatLng(-6.2000, 106.8420),
    LatLng(-6.2010, 106.8500),
    LatLng(-6.1960, 106.8505),
    LatLng(-6.1955, 106.8430),
  ]),
];

/// Bold green sample evacuation route polyline. Starts at the current-location
/// dot and ends at the recommended shelter (Masjid Al-Ikhlas).
const List<LatLng> kRoutePolyline = [
  LatLng(-6.2088, 106.8456),
  LatLng(-6.2070, 106.8460),
  LatLng(-6.2050, 106.8466),
  LatLng(-6.2030, 106.8470),
  LatLng(-6.2008, 106.8475),
  LatLng(-6.1985, 106.8470),
];

const Distance _distance = Distance();

/// Cumulative distance (meters) to each vertex of [kRoutePolyline].
List<double> _routeCumulative() {
  final cum = <double>[0];
  for (var i = 1; i < kRoutePolyline.length; i++) {
    cum.add(cum[i - 1] + _distance(kRoutePolyline[i - 1], kRoutePolyline[i]));
  }
  return cum;
}

/// Total walking length of the evacuation route, in meters.
double get kRouteLengthMeters => _routeCumulative().last;

/// Interpolated point along the route at fraction [t] in [0, 1].
LatLng routePointAt(double t) {
  t = t.clamp(0.0, 1.0);
  final cum = _routeCumulative();
  final target = cum.last * t;
  for (var i = 1; i < kRoutePolyline.length; i++) {
    if (cum[i] >= target) {
      final segLen = cum[i] - cum[i - 1];
      final f = segLen == 0 ? 0.0 : (target - cum[i - 1]) / segLen;
      final a = kRoutePolyline[i - 1];
      final b = kRoutePolyline[i];
      return LatLng(
        a.latitude + (b.latitude - a.latitude) * f,
        a.longitude + (b.longitude - a.longitude) * f,
      );
    }
  }
  return kRoutePolyline.last;
}

/// Splits the route at fraction [t] into the already-traveled portion and the
/// remaining portion, so the map can shade them differently.
({List<LatLng> traveled, List<LatLng> remaining}) splitRouteAt(double t) {
  t = t.clamp(0.0, 1.0);
  final cum = _routeCumulative();
  final target = cum.last * t;
  final point = routePointAt(t);
  final traveled = <LatLng>[kRoutePolyline.first];
  final remaining = <LatLng>[];
  for (var i = 1; i < kRoutePolyline.length; i++) {
    if (cum[i] < target) {
      traveled.add(kRoutePolyline[i]);
    } else {
      traveled.add(point);
      remaining
        ..add(point)
        ..addAll(kRoutePolyline.sublist(i));
      break;
    }
  }
  if (remaining.isEmpty) remaining.add(kRoutePolyline.last);
  return (traveled: traveled, remaining: remaining);
}

// ---------------------------------------------------------------------------
// Turn-by-turn directions (for the route steps screen)
// ---------------------------------------------------------------------------

class RouteStep {
  final IconData icon;
  final String instruction;

  /// Distance walked during this step. Empty for the origin/destination rows.
  final String distance;

  const RouteStep(this.icon, this.instruction, this.distance);
}

/// Hardcoded directions from the user's location to the recommended shelter.
/// Distances sum to ~600 m to match the route summary.
const List<RouteStep> kRouteSteps = [
  RouteStep(Icons.my_location_rounded, 'Lokasi Anda saat ini', ''),
  RouteStep(Icons.arrow_upward_rounded, 'Jalan ke utara di Jl. Mawar', '200 m'),
  RouteStep(Icons.turn_left_rounded, 'Belok kiri ke Jl. Merdeka', '250 m'),
  RouteStep(
      Icons.straight_rounded, 'Lurus melewati persimpangan pasar', '100 m'),
  RouteStep(
      Icons.turn_right_rounded, 'Belok kanan ke Jl. Al-Ikhlas', '50 m'),
  RouteStep(Icons.flag_rounded, 'Tiba di Masjid Al-Ikhlas', ''),
];

// ---------------------------------------------------------------------------
// Shelters
// ---------------------------------------------------------------------------

class Shelter {
  final String name;
  final String address;
  final String distance; // e.g. "600 m"
  final String walkTime; // e.g. "8 menit"
  final int capacityUsed;
  final int capacityTotal;
  final bool isOpen;
  final bool isAccessible;
  final bool recommended;
  final LatLng location;

  const Shelter({
    required this.name,
    required this.address,
    required this.distance,
    required this.walkTime,
    required this.capacityUsed,
    required this.capacityTotal,
    required this.isOpen,
    required this.isAccessible,
    required this.location,
    this.recommended = false,
  });

  double get capacityRatio =>
      capacityTotal == 0 ? 0 : capacityUsed / capacityTotal;
  int get spaceLeft => capacityTotal - capacityUsed;
  bool get hasSpace => spaceLeft > 0;
}

const List<Shelter> kShelters = [
  Shelter(
    name: 'Masjid Al-Ikhlas',
    address: 'Jl. Merdeka No. 12',
    distance: '600 m',
    walkTime: '8 menit',
    capacityUsed: 120,
    capacityTotal: 300,
    isOpen: true,
    isAccessible: true,
    recommended: true,
    location: LatLng(-6.1985, 106.8470),
  ),
  Shelter(
    name: 'SDN 03 Menteng',
    address: 'Jl. Pendidikan No. 4',
    distance: '850 m',
    walkTime: '11 menit',
    capacityUsed: 210,
    capacityTotal: 250,
    isOpen: true,
    isAccessible: false,
    location: LatLng(-6.2010, 106.8505),
  ),
  Shelter(
    name: 'Balai Warga RW 05',
    address: 'Jl. Kenanga No. 8',
    distance: '1.1 km',
    walkTime: '14 menit',
    capacityUsed: 60,
    capacityTotal: 150,
    isOpen: true,
    isAccessible: true,
    location: LatLng(-6.1960, 106.8430),
  ),
  Shelter(
    name: 'GOR Bina Bangsa',
    address: 'Jl. Olahraga No. 1',
    distance: '1.6 km',
    walkTime: '21 menit',
    capacityUsed: 480,
    capacityTotal: 500,
    isOpen: false,
    isAccessible: true,
    location: LatLng(-6.1940, 106.8490),
  ),
];

// ---------------------------------------------------------------------------
// Official warning
// ---------------------------------------------------------------------------

class OfficialWarning {
  final Severity severity;
  final String title;
  final String source;
  final String issuedAt;
  final String validUntil;
  final String summary;
  final List<String> affectedAreas;

  const OfficialWarning({
    required this.severity,
    required this.title,
    required this.source,
    required this.issuedAt,
    required this.validUntil,
    required this.summary,
    required this.affectedAreas,
  });
}

const OfficialWarning kWarning = OfficialWarning(
  severity: Severity.awas,
  title: 'Peringatan Dini Banjir',
  source: 'BMKG — Stasiun Jakarta',
  issuedAt: 'Hari ini, 14.05 WIB',
  validUntil: 'Berlaku hingga 20.00 WIB',
  summary:
      'Hujan dengan intensitas lebat diperkirakan terus mengguyur wilayah '
      'Jakarta Pusat. Tinggi muka air di Pintu Air Manggarai meningkat ke '
      'Siaga 1. Warga di bantaran sungai diminta segera mengungsi ke tempat '
      'aman yang telah ditentukan.',
  affectedAreas: [
    'Kel. Kampung Melayu',
    'Kel. Bukit Duri',
    'Kel. Kebon Baru',
    'Bantaran Ciliwung',
  ],
);

// ---------------------------------------------------------------------------
// First-actions checklist
// ---------------------------------------------------------------------------

class ChecklistAction {
  final IconData icon;
  final String action;
  final String detail;
  const ChecklistAction(this.icon, this.action, this.detail);
}

const List<ChecklistAction> kFirstActions = [
  ChecklistAction(
    Icons.power_settings_new_rounded,
    'Matikan aliran listrik',
    'Turunkan sakelar utama untuk mencegah korsleting saat air masuk.',
  ),
  ChecklistAction(
    Icons.backpack_rounded,
    'Siapkan tas siaga',
    'Dokumen penting, obat, air, senter, dan power bank.',
  ),
  ChecklistAction(
    Icons.groups_rounded,
    'Kumpulkan keluarga',
    'Pastikan semua anggota keluarga bersama dan siap bergerak.',
  ),
  ChecklistAction(
    Icons.upgrade_rounded,
    'Pindahkan barang ke tempat tinggi',
    'Amankan barang berharga dari jangkauan air.',
  ),
  ChecklistAction(
    Icons.directions_walk_rounded,
    'Ikuti rute evakuasi',
    'Menuju shelter terdekat melalui jalur aman yang disarankan.',
  ),
];

// ---------------------------------------------------------------------------
// Family members
// ---------------------------------------------------------------------------

class FamilyMember {
  final String name;
  final String relation;
  final StatusLevel status;
  final String lastSeen;
  final String distance;
  const FamilyMember({
    required this.name,
    required this.relation,
    required this.status,
    required this.lastSeen,
    required this.distance,
  });
}

const List<FamilyMember> kFamily = [
  FamilyMember(
    name: 'Siti Rahma',
    relation: 'Istri',
    status: StatusLevel.safe,
    lastSeen: '2 menit lalu',
    distance: 'Di shelter Al-Ikhlas',
  ),
  FamilyMember(
    name: 'Budi Santoso',
    relation: 'Anak',
    status: StatusLevel.safe,
    lastSeen: '5 menit lalu',
    distance: '300 m dari kamu',
  ),
  FamilyMember(
    name: 'Ibu Aminah',
    relation: 'Orang tua',
    status: StatusLevel.caution,
    lastSeen: '12 menit lalu',
    distance: '1.2 km — dalam perjalanan',
  ),
  FamilyMember(
    name: 'Andi Pratama',
    relation: 'Anak',
    status: StatusLevel.danger,
    lastSeen: '28 menit lalu',
    distance: 'Belum diketahui',
  ),
];

// ---------------------------------------------------------------------------
// Trusted sources (Settings)
// ---------------------------------------------------------------------------

class TrustedSource {
  final String name;
  final String fullName;
  const TrustedSource(this.name, this.fullName);
}

const List<TrustedSource> kTrustedSources = [
  TrustedSource('BMKG', 'Badan Meteorologi, Klimatologi, dan Geofisika'),
  TrustedSource('BNPB', 'Badan Nasional Penanggulangan Bencana'),
  TrustedSource('BPBD', 'Badan Penanggulangan Bencana Daerah DKI Jakarta'),
];

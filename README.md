# SIAGA — Civilian Evacuation Guidance (UI Prototype)

A **front-end-only, clickable prototype** of SIAGA, a civilian evacuation
guidance app for flood and landslide emergencies in Indonesia. This build is
about the **interface**: pixel-faithful screens, smooth navigation, and
toggleable visual states for demos. There is **no backend** — no database,
networking, GPS, or routing engine. Every "real" value is hardcoded sample
data in `lib/sample_data.dart`.

Primary UI language is **Bahasa Indonesia**.

## Run

```bash
flutter pub get
flutter run        # pick a device, or: flutter run -d chrome
```

## Demo tips

- On the **Beranda (Home)** screen, **long-press the status banner** or tap the
  **"Demo: ganti status"** chip to cycle `ZONA BAHAYA → WASPADA → AMAN`. The
  same widget renders the safe-state home — colors, text, and icon all change
  together from a single status enum.
- All buttons either navigate or toggle local visual state. Switches/toggles
  change appearance only.

## Screens (one line each)

| FR | Screen | What it shows |
|----|--------|---------------|
| FR-1 | **Onboarding** (`/onboarding`) | Logo, tagline, 3 value rows, "Izinkan Akses Lokasi" (navigates only). |
| FR-2 | **Home / Danger Status** (`/home`) | Enum-driven hero banner, navy trust strip, quick-action cards, state-cycling dev chip. |
| FR-3 | **Danger-Zone Map** (`/map`) | `flutter_map` with red/amber/green zone polygons, location dot, shelter markers, legend, draggable shelter sheet. |
| FR-4 | **Official Warning** (`/warning`) | Severity header (waspada/siaga/awas), bordered verified trust card, summary, affected-area chips. |
| FR-5 | **First-Actions Checklist** (`/actions`) | "Lakukan sekarang" header + progress bar; tappable ordered checklist cards. |
| FR-6 | **Nearest-Shelter Finder** (`/shelters`) | Map preview, filter chips, shelter list sorted nearest-first with capacity bars. |
| FR-7 | **Safe-Route Navigation** (`/route`) | Navy turn banner, green route polyline over shaded zones, progress sheet, "Saya sudah aman". |
| FR-8 | **Family Check-in** (`/family`) | One-tap "Saya Aman", "3 dari 4 aman" summary, family rows with status pills. |
| FR-9 | **Settings / Offline & Trust** (`/settings`) | Styled switches, offline-map download card, verified trusted sources, language & accessibility toggles. |
|  | **Info hub** (`/info`) | Directory tab linking warning, actions, shelters, settings, plus emergency numbers. |

The four bottom-nav tabs — **Beranda, Peta, Keluarga, Info** — are hosted by a
`go_router` `StatefulShellRoute`; the remaining screens are pushed on top.

## Design system

Centralized tokens in `lib/theme/`:

- **Color = meaning** (consistent app-wide): danger `#D32F2F`, caution `#F9A825`,
  safe `#2E7D32`, official/navy `#1E3A5F`, surface `#FAFAFA`.
- **`StatusLevel` / `Severity` enums drive color, label, and icon together**
  via a single `StatusStyle` source of truth (`lib/theme/status_style.dart`).
- Large high-contrast type (status ≥ 48sp), ≥ 56dp tap targets, 16dp rounded
  cards, icon + text labels (never icon-only). System text scaling is respected
  (clamped so the huge status type never breaks layout).

## Project layout

```
lib/
  main.dart            # entry
  app.dart             # MaterialApp.router + theme
  app_state.dart       # ValueNotifier<StatusLevel> for demo state cycling
  sample_data.dart     # ALL hardcoded mock content
  theme/               # colors, typography, spacing, status styles, ThemeData
  router/              # go_router routes (+ stateful bottom-nav shell)
  widgets/             # StatusBanner, TrustStrip, ShelterCard, ActionTile,
                       #   FamilyRow, PrimaryButton, BottomNav, ZoneMap, …
  screens/             # one file per screen above
```

## Stack

Flutter (Material 3, Dart 3) · `go_router` · `flutter_map` + OpenStreetMap
tiles (visual only) · `google_fonts` (Plus Jakarta Sans). No other packages.

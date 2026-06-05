import 'package:flutter/foundation.dart';

import 'theme/status_style.dart';

/// Minimal app-wide visual state for the demo. Just enough to toggle the
/// danger ↔ caution ↔ safe status that drives the home banner and map.
class AppState {
  AppState._();

  /// Current danger level. Cycled from the home screen's dev control.
  static final ValueNotifier<StatusLevel> status =
      ValueNotifier<StatusLevel>(StatusLevel.danger);

  static void cycleStatus() {
    final values = StatusLevel.values;
    final next = values[(status.value.index + 1) % values.length];
    status.value = next;
  }
}

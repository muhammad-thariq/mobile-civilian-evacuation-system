import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  final config = ClarityConfig(
    projectId: 'x26e73x16m',
    // Use LogLevel.Verbose while testing to debug initialization issues.
    logLevel: LogLevel.None,
  );

  runApp(
    ClarityWidget(
      app: const SiagaApp(),
      clarityConfig: config,
    ),
  );
}

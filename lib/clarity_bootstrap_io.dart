import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/widgets.dart';

/// Android/iOS build: wrap the app with the Clarity SDK.
Widget wrapWithClarity(Widget app) {
  final config = ClarityConfig(
    projectId: 'x26e73x16m',
    // Use LogLevel.Verbose while testing to debug initialization issues.
    logLevel: LogLevel.None,
  );
  return ClarityWidget(app: app, clarityConfig: config);
}

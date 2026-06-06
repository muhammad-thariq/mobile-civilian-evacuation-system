import 'package:flutter/widgets.dart';

/// Web build: Clarity is handled by the JS snippet in `web/index.html`, so the
/// (mobile-only) `clarity_flutter` SDK is never imported here. This keeps its
/// `xxh3` dependency out of the `dart2js` compile.
Widget wrapWithClarity(Widget app) => app;

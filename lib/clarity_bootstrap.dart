// Platform-conditional Clarity setup.
//
// On Android/iOS we wrap the app with the `clarity_flutter` SDK. On web we
// must NOT touch that SDK: it depends on `xxh3`, which uses 64-bit integer
// literals that `dart2js` cannot compile. Web heatmaps are collected via the
// Clarity JavaScript snippet in `web/index.html` instead.
export 'clarity_bootstrap_web.dart'
    if (dart.library.io) 'clarity_bootstrap_io.dart';

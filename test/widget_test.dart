// Smoke test for the SIAGA UI prototype: the onboarding screen renders and
// "Izinkan Akses Lokasi" navigates into the home shell.

import 'package:flutter_test/flutter_test.dart';

import 'package:dpp_flutter/app.dart';

void main() {
  testWidgets('Onboarding renders and navigates to home',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiagaApp());
    await tester.pumpAndSettle();

    // Onboarding tagline is visible.
    expect(find.text('Tahu bahaya, tahu jalan keluar'), findsOneWidget);

    // Tapping the primary button navigates to the home status screen.
    await tester.tap(find.text('Izinkan Akses Lokasi'));
    await tester.pumpAndSettle();

    expect(find.text('ZONA BAHAYA'), findsOneWidget);
  });
}

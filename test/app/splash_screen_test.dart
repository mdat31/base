import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/app/splash_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('shows a loading indicator', (tester) async {
    await tester.pumpApp(const SplashScreen());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

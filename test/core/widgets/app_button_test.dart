import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/widgets/app_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('primary renders FilledButton and handles taps', (tester) async {
    var taps = 0;
    await tester.pumpApp(AppButton(label: 'Go', onPressed: () => taps++));

    expect(find.byType(FilledButton), findsOneWidget);
    await tester.tap(find.text('Go'));
    expect(taps, 1);
  });

  testWidgets('variants map to Material buttons', (tester) async {
    await tester.pumpApp(
      Column(
        children: [
          AppButton.secondary(label: 'S', onPressed: () {}, icon: Icons.add),
          AppButton.text(label: 'T', onPressed: () {}),
        ],
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('loading shows spinner and disables taps', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      AppButton(label: 'Go', isLoading: true, onPressed: () => taps++),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Go'), findsNothing);
    await tester.tap(find.byType(FilledButton));
    expect(taps, 0);
  });
}

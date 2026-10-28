import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox();
          },
        ),
      ),
    );
    return context;
  }

  for (final type in AppSnackBarType.values) {
    testWidgets('showAppSnackBar ${type.name}', (tester) async {
      final context = await pumpHost(tester);

      context.showAppSnackBar('Hello', type: type);
      await tester.pump();

      expect(find.text('Hello'), findsOneWidget);
    });
  }

  group('showAppConfirmDialog', () {
    Future<bool?> open(WidgetTester tester, String buttonText) async {
      final context = await pumpHost(tester);
      bool? result;
      final future = showAppConfirmDialog(
        context,
        title: 'Delete?',
        message: 'Sure?',
        isDestructive: true,
      ).then((value) => result = value);
      await tester.pumpAndSettle();
      expect(find.text('Delete?'), findsOneWidget);

      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();
      await future;
      return result;
    }

    testWidgets('resolves true on confirm', (tester) async {
      expect(await open(tester, l10nEn.confirm), isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      expect(await open(tester, l10nEn.cancel), isFalse);
    });
  });

  group('AppAvatar', () {
    test('initials use the first two words', () {
      expect(const AppAvatar(name: 'emily rose johnson').initials, 'ER');
      expect(const AppAvatar(name: '  ').initials, '');
    });

    testWidgets('renders initials without image', (tester) async {
      await tester.pumpApp(const AppAvatar(name: 'Emily Johnson'));

      expect(find.text('EJ'), findsOneWidget);
    });
  });
}

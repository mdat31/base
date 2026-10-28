import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mod/app/router/main_shell.dart';
import 'package:mod/core/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('switches between tabs', (tester) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => MainShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(path: '/a', builder: (_, _) => const Text('A'))],
            ),
            StatefulShellBranch(
              routes: [GoRoute(path: '/b', builder: (_, _) => const Text('B'))],
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    expect(find.text('A'), findsOneWidget);

    await tester.tap(find.text(l10nEn.navSettings));
    await tester.pumpAndSettle();
    expect(find.text('B'), findsOneWidget);
  });
}

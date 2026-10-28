import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppErrorView shows message and retries', (tester) async {
    var retries = 0;
    await tester.pumpApp(
      AppErrorView(message: 'Failed', onRetry: () => retries++),
    );

    expect(find.text('Failed'), findsOneWidget);
    await tester.tap(find.text(l10nEn.retry));
    expect(retries, 1);
  });

  testWidgets('AppErrorView hides retry without callback', (tester) async {
    await tester.pumpApp(const AppErrorView(message: 'Failed'));

    expect(find.text(l10nEn.retry), findsNothing);
  });

  testWidgets('AppEmptyView uses default message', (tester) async {
    await tester.pumpApp(const AppEmptyView());

    expect(find.text(l10nEn.emptyData), findsOneWidget);
  });

  testWidgets('AppMessageView shows title', (tester) async {
    await tester.pumpApp(
      const AppMessageView(icon: Icons.info, title: 'Title', message: 'Body'),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });

  testWidgets('AppLoadingIndicator shows a spinner', (tester) async {
    await tester.pumpApp(const AppLoadingIndicator());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

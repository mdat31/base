import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/extensions/context_extensions.dart';
import 'package:mod/core/theme/app_theme.dart';

void main() {
  test('light and dark themes use matching brightness', () {
    expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
  });

  testWidgets('context extensions expose theme and media', (tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            captured = context;
            return const Scaffold(body: TextField(autofocus: true));
          },
        ),
      ),
    );
    await tester.pump();

    expect(captured.theme, isA<ThemeData>());
    expect(captured.colorScheme, captured.theme.colorScheme);
    expect(captured.textTheme, captured.theme.textTheme);
    expect(captured.screenSize, isNot(Size.zero));

    FocusNode focusNode() =>
        tester.widget<EditableText>(find.byType(EditableText)).focusNode;
    expect(focusNode().hasFocus, isTrue);

    captured.hideKeyboard();
    await tester.pump();
    expect(focusNode().hasFocus, isFalse);
  });
}

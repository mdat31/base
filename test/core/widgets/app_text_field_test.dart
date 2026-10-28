import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/widgets/app_text_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('shows label and reports changes', (tester) async {
    String? changed;
    await tester.pumpApp(
      Scaffold(
        body: AppTextField(
          label: 'Name',
          prefixIcon: Icons.person,
          onChanged: (value) => changed = value,
        ),
      ),
    );

    expect(find.text('Name'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'abc');
    expect(changed, 'abc');
  });

  testWidgets('password toggle switches obscured text', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: AppTextField(label: 'Password', obscureText: true)),
    );

    EditableText editable() => tester.widget(find.byType(EditableText));
    expect(editable().obscureText, isTrue);

    await tester.tap(find.byTooltip(l10nEn.showPassword));
    await tester.pump();
    expect(editable().obscureText, isFalse);
    expect(find.byTooltip(l10nEn.hidePassword), findsOneWidget);
  });

  testWidgets('shows validator errors', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpApp(
      Scaffold(
        body: Form(
          key: formKey,
          child: AppTextField(validator: (_) => 'Required'),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [widget] inside a localized, themed [MaterialApp].
  Future<void> pumpApp(Widget widget, {Locale locale = const Locale('en')}) {
    return pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }
}

/// English strings for assertions, so tests don't hard-code copy.
final AppLocalizations l10nEn = lookupAppLocalizations(const Locale('en'));

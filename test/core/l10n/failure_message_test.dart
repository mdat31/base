import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

void main() {
  test('maps every Failure to a localized message', () {
    expect(
      const Failure.server(message: 'From API').localizedMessage(l10nEn),
      'From API',
    );
    expect(
      const Failure.server(message: '').localizedMessage(l10nEn),
      l10nEn.errorServer,
    );
    expect(
      const Failure.unauthorized().localizedMessage(l10nEn),
      l10nEn.errorUnauthorized,
    );
    expect(
      const Failure.network().localizedMessage(l10nEn),
      l10nEn.errorNetwork,
    );
    expect(
      const Failure.timeout().localizedMessage(l10nEn),
      l10nEn.errorTimeout,
    );
    expect(const Failure.cache().localizedMessage(l10nEn), l10nEn.errorCache);
    expect(
      const Failure.unexpected().localizedMessage(l10nEn),
      l10nEn.errorUnexpected,
    );
  });

  test('every supported locale defines a language name', () {
    for (final locale in AppLocalizations.supportedLocales) {
      expect(lookupAppLocalizations(locale).languageName, isNotEmpty);
    }
  });
}

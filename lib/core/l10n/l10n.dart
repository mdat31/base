import 'package:flutter/widgets.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/l10n/gen/app_localizations.dart';

export 'package:mod/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// User-facing text for a [Failure]. Server messages are shown as-is because
/// the backend already localizes them; everything else uses ARB strings.
extension FailureMessageX on Failure {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    ServerFailure(:final message) when message.isNotEmpty => message,
    ServerFailure() => l10n.errorServer,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    NetworkFailure() => l10n.errorNetwork,
    TimeoutFailure() => l10n.errorTimeout,
    CacheFailure() => l10n.errorCache,
    UnexpectedFailure() => l10n.errorUnexpected,
  };
}

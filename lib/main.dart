import 'package:mod/app/app.dart';
import 'package:mod/bootstrap.dart';

/// Single entry point for every flavor:
/// `flutter run --flavor dev --dart-define-from-file=config/dev.json`
Future<void> main() => bootstrap(() => const App());

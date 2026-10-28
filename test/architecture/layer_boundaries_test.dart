import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards Clean Architecture dependency rules on every `flutter test`.
void main() {
  final featuresDir = Directory('lib/features');
  final features = featuresDir
      .listSync()
      .whereType<Directory>()
      .map((dir) => dir.uri.pathSegments.where((s) => s.isNotEmpty).last)
      .toList();

  Iterable<(String, String)> importsIn(String path) sync* {
    final dir = Directory(path);
    if (!dir.existsSync()) return;
    final files = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.endsWith('.g.dart') &&
              !file.path.endsWith('.freezed.dart'),
        );
    final importPattern = RegExp(r'''^import\s+['"]([^'"]+)['"]''');
    for (final file in files) {
      for (final line in file.readAsLinesSync()) {
        final match = importPattern.firstMatch(line.trim());
        if (match != null) yield (file.path, match.group(1)!);
      }
    }
  }

  List<String> violations(String path, bool Function(String import) isBad) => [
    for (final (file, import) in importsIn(path))
      if (isBad(import)) '$file -> $import',
  ];

  test('features exist', () => expect(features, isNotEmpty));

  for (final feature in features) {
    group('feature "$feature"', () {
      final root = 'lib/features/$feature';

      test('domain is pure Dart and independent of data/presentation', () {
        expect(
          violations(
            '$root/domain',
            (import) =>
                import.startsWith('package:flutter/') ||
                import.contains('/data/') ||
                import.contains('/presentation/') ||
                import.startsWith('package:dio/') ||
                import.contains('core/error/run_guarded.dart') ||
                import.contains('core/di/'),
          ),
          isEmpty,
        );
      });

      test('data does not import presentation or widgets', () {
        expect(
          violations(
            '$root/data',
            (import) =>
                import.contains('/presentation/') ||
                import == 'package:flutter/material.dart' ||
                import == 'package:flutter/widgets.dart',
          ),
          isEmpty,
        );
      });

      test('presentation does not import data or the service locator', () {
        expect(
          violations(
            '$root/presentation',
            (import) =>
                import.contains('/data/') ||
                import.contains('core/di/') ||
                import.contains('app/di/') ||
                import.startsWith('package:get_it/') ||
                import.startsWith('package:dio/'),
          ),
          isEmpty,
        );
      });

      test('no feature imports another feature data layer', () {
        expect(
          violations(
            root,
            (import) =>
                import.startsWith('package:mod/features/') &&
                !import.startsWith('package:mod/features/$feature/') &&
                import.contains('/data/'),
          ),
          isEmpty,
        );
      });
    });
  }

  test('core does not depend on features or the app layer', () {
    expect(
      violations(
        'lib/core',
        (import) =>
            import.contains('/features/') ||
            import.startsWith('package:mod/app/'),
      ),
      isEmpty,
    );
  });
}

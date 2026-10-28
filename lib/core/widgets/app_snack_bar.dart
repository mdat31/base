import 'package:flutter/material.dart';
import 'package:mod/core/theme/app_colors.dart';

enum AppSnackBarType { info, success, error }

extension AppSnackBarX on BuildContext {
  void showAppSnackBar(
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
  }) {
    final colorScheme = Theme.of(this).colorScheme;
    final (background, foreground) = switch (type) {
      AppSnackBarType.info => (
        colorScheme.inverseSurface,
        colorScheme.onInverseSurface,
      ),
      AppSnackBarType.success => (AppColors.success, Colors.white),
      AppSnackBarType.error => (colorScheme.error, colorScheme.onError),
    };
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: background,
          content: Text(message, style: TextStyle(color: foreground)),
        ),
      );
  }
}

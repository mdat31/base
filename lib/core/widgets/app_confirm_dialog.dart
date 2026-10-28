import 'package:flutter/material.dart';
import 'package:mod/core/l10n/l10n.dart';

/// Shows a confirm/cancel dialog. Resolves to `true` only on confirm.
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  bool isDestructive = false,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final colorScheme = Theme.of(dialogContext).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: colorScheme.error)
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel ?? l10n.confirm),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

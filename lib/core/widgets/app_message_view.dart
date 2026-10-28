import 'package:flutter/material.dart';
import 'package:mod/core/extensions/context_extensions.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_spacing.dart';
import 'package:mod/core/widgets/app_button.dart';

/// Centered icon + message + optional action. Base for empty/error states.
class AppMessageView extends StatelessWidget {
  const AppMessageView({
    required this.icon,
    required this.message,
    super.key,
    this.title,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final actionLabel = this.actionLabel;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: context.colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            if (title != null) ...[
              Text(
                title,
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Text(
              message,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.secondary(label: actionLabel, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, super.key, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => AppMessageView(
    icon: Icons.error_outline,
    message: message,
    actionLabel: context.l10n.retry,
    onAction: onRetry,
  );
}

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => AppMessageView(
    icon: Icons.inbox_outlined,
    message: message ?? context.l10n.emptyData,
  );
}

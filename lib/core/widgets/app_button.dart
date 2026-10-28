import 'package:flutter/material.dart';
import 'package:mod/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text }

/// Single button entry point so every screen shares size, shape and the
/// loading state.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
  }) : variant = AppButtonVariant.text;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final callback = isLoading ? null : onPressed;
    final child = isLoading
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : _Label(label: label, icon: icon);

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: callback,
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: callback,
        child: child,
      ),
      AppButtonVariant.text => TextButton(onPressed: callback, child: child),
    };
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.xs),
        Flexible(child: Text(label)),
      ],
    );
  }
}

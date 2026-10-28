import 'package:flutter/material.dart';
import 'package:mod/core/extensions/context_extensions.dart';
import 'package:mod/core/theme/app_spacing.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(title, style: context.textTheme.titleSmall),
      const SizedBox(height: AppSpacing.xs),
      child,
    ],
  );
}

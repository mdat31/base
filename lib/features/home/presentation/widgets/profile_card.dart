import 'package:flutter/material.dart';
import 'package:mod/core/extensions/context_extensions.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_spacing.dart';
import 'package:mod/core/widgets/widgets.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.user, super.key});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppAvatar(
              name: user.fullName,
              imageUrl: user.avatarUrl,
              radius: 40,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.homeGreeting(
                user.firstName.isEmpty ? user.username : user.firstName,
              ),
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: Text(l10n.profileUsername),
              subtitle: Text(user.username),
            ),
            if (user.email.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(l10n.profileEmail),
                subtitle: Text(user.email),
              ),
          ],
        ),
      ),
    );
  }
}

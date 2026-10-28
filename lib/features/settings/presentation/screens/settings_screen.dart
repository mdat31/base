import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_spacing.dart';
import 'package:mod/core/widgets/widgets.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mod/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:mod/features/settings/presentation/widgets/language_selector.dart';
import 'package:mod/features/settings/presentation/widgets/settings_section.dart';
import 'package:mod/features/settings/presentation/widgets/theme_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = context.l10n;
    final authBloc = context.read<AuthBloc>();
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmMessage,
      confirmLabel: l10n.logout,
      isDestructive: true,
    );
    if (confirmed) authBloc.add(const AuthLogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SettingsSection(
            title: l10n.themeSection,
            child: BlocSelector<SettingsCubit, SettingsState, ThemeMode>(
              selector: (state) => state.themeMode,
              builder: (context, themeMode) => ThemeSelector(
                value: themeMode,
                onChanged: context.read<SettingsCubit>().changeThemeMode,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SettingsSection(
            title: l10n.languageSection,
            child: BlocSelector<SettingsCubit, SettingsState, Locale?>(
              selector: (state) => state.locale,
              builder: (context, locale) => LanguageSelector(
                value: locale,
                onChanged: context.read<SettingsCubit>().changeLocale,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.secondary(
            key: const Key('settings_logout'),
            label: l10n.logout,
            icon: Icons.logout,
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}

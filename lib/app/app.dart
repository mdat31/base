import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mod/app/di/injection.dart';
import 'package:mod/app/router/app_router.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/core/l10n/l10n.dart';
import 'package:mod/core/theme/app_theme.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mod/features/settings/presentation/cubit/settings_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<AuthBloc>()..add(const AuthSubscriptionRequested()),
        ),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  // Created once: rebuilding GoRouter would reset navigation.
  late final GoRouter _router = createAppRouter(context.read<AuthBloc>());

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;
    return MaterialApp.router(
      title: getIt<AppConfig>().appName,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

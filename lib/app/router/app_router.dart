import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mod/app/di/injection.dart';
import 'package:mod/app/router/app_routes.dart';
import 'package:mod/app/router/auth_redirect.dart';
import 'package:mod/app/router/main_shell.dart';
import 'package:mod/app/router/stream_listenable.dart';
import 'package:mod/app/splash_screen.dart';
import 'package:mod/core/config/app_config.dart';
import 'package:mod/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mod/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:mod/features/auth/presentation/login/screens/login_screen.dart';
import 'package:mod/features/home/presentation/cubit/home_cubit.dart';
import 'package:mod/features/home/presentation/screens/home_screen.dart';
import 'package:mod/features/settings/presentation/screens/settings_screen.dart';

/// Composition root for navigation: the only place screens meet their
/// blocs from the service locator.
GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: !getIt<AppConfig>().isProd,
    refreshListenable: StreamListenable(authBloc.stream),
    redirect: (context, state) => resolveAuthRedirect(
      status: authBloc.state.status,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: LoginScreen(showDemoHint: !getIt<AppConfig>().isProd),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<HomeCubit>()..load(),
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

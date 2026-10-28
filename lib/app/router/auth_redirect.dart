import 'package:mod/app/router/app_routes.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';

/// Pure redirect rules, kept out of GoRouter so they are unit-testable.
/// Returns the path to go to, or `null` to stay.
String? resolveAuthRedirect({
  required AuthStatus status,
  required String location,
}) {
  final isSplash = location == AppRoutes.splash;
  final isPublic = AppRoutes.public.contains(location);

  return switch (status) {
    AuthStatus.unknown => isSplash ? null : AppRoutes.splash,
    AuthStatus.unauthenticated => isPublic ? null : AppRoutes.login,
    AuthStatus.authenticated => isSplash || isPublic ? AppRoutes.home : null,
  };
}

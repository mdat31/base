import 'package:flutter_test/flutter_test.dart';
import 'package:mod/app/router/app_routes.dart';
import 'package:mod/app/router/auth_redirect.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';

void main() {
  String? redirect(AuthStatus status, String location) =>
      resolveAuthRedirect(status: status, location: location);

  test('unknown status always shows splash', () {
    expect(redirect(AuthStatus.unknown, AppRoutes.home), AppRoutes.splash);
    expect(redirect(AuthStatus.unknown, AppRoutes.splash), isNull);
  });

  test('unauthenticated users are sent to login', () {
    expect(
      redirect(AuthStatus.unauthenticated, AppRoutes.settings),
      AppRoutes.login,
    );
    expect(
      redirect(AuthStatus.unauthenticated, AppRoutes.splash),
      AppRoutes.login,
    );
    expect(redirect(AuthStatus.unauthenticated, AppRoutes.login), isNull);
  });

  test('authenticated users skip splash and login', () {
    expect(redirect(AuthStatus.authenticated, AppRoutes.login), AppRoutes.home);
    expect(
      redirect(AuthStatus.authenticated, AppRoutes.splash),
      AppRoutes.home,
    );
    expect(redirect(AuthStatus.authenticated, AppRoutes.settings), isNull);
  });
}

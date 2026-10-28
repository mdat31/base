/// Route paths. Keep every path here so deep links have one source of truth.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const settings = '/settings';

  /// Routes reachable without a session.
  static const public = {login};
}

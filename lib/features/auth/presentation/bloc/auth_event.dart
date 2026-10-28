part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// Starts listening to the session status. Dispatch once at app start.
final class AuthSubscriptionRequested extends AuthEvent {
  const AuthSubscriptionRequested();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

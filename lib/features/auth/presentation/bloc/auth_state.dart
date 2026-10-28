part of 'auth_bloc.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({@Default(AuthStatus.unknown) AuthStatus status}) =
      _AuthState;
}

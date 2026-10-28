import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mod/features/auth/domain/usecases/watch_auth_status_use_case.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// App-wide session state. The router redirects based on [AuthState.status].
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._watchAuthStatus, this._logout) : super(const AuthState()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final WatchAuthStatusUseCase _watchAuthStatus;
  final LogoutUseCase _logout;

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) => emit.forEach(
    _watchAuthStatus(const NoParams()),
    onData: (status) => AuthState(status: status),
  );

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // The status stream emits `unauthenticated` on success.
    await _logout(const NoParams());
  }
}

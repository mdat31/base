import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/features/auth/domain/usecases/login_use_case.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login) : super(const LoginState.initial());

  final LoginUseCase _login;

  Future<void> submit({
    required String username,
    required String password,
  }) async {
    if (state is LoginLoading) return;
    emit(const LoginState.loading());
    final result = await _login(
      LoginParams(username: username, password: password),
    );
    if (isClosed) return;
    emit(result.fold(LoginState.failure, (_) => const LoginState.success()));
  }
}

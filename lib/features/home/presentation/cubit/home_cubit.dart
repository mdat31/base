import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/core/error/failure.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/user_entity.dart';
import 'package:mod/features/auth/domain/usecases/get_current_user_use_case.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getCurrentUser) : super(const HomeState.loading());

  final GetCurrentUserUseCase _getCurrentUser;

  /// Initial load and retry. Keeps loaded data visible while refreshing.
  Future<void> load() async {
    if (state is HomeFailure) emit(const HomeState.loading());
    final result = await _getCurrentUser(const NoParams());
    if (isClosed) return;
    emit(result.fold(HomeState.failure, HomeState.loaded));
  }
}

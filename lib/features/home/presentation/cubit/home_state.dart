part of 'home_cubit.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded(UserEntity user) = HomeLoaded;
  const factory HomeState.failure(Failure failure) = HomeFailure;
}

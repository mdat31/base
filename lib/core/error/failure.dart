import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Domain-level error. Pure Dart: shared by every layer except data sources,
/// which throw [AppException]s instead.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;
  const factory Failure.unauthorized({
    @Default('Unauthorized') String message,
  }) = UnauthorizedFailure;
  const factory Failure.network({@Default('No connection') String message}) =
      NetworkFailure;
  const factory Failure.timeout({
    @Default('Request timed out') String message,
  }) = TimeoutFailure;
  const factory Failure.cache({
    @Default('Local storage error') String message,
  }) = CacheFailure;
  const factory Failure.unexpected({
    @Default('Unexpected error') String message,
  }) = UnexpectedFailure;
}

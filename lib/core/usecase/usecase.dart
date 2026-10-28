import 'package:mod/core/error/result.dart';

/// One business action. Keep implementations small (Single Responsibility)
/// and depend on repository contracts only (Dependency Inversion).
abstract interface class UseCase<T, Params> {
  FutureResult<T> call(Params params);
}

/// Use case that exposes a stream instead of a single result.
abstract interface class StreamUseCase<T, Params> {
  Stream<T> call(Params params);
}

/// Parameter for use cases that need no input.
final class NoParams {
  const NoParams();
}

import 'package:fpdart/fpdart.dart';
import 'package:mod/core/error/failure.dart';

export 'package:fpdart/fpdart.dart' show Either, Left, Right, Unit, unit;

/// Result type returned by repositories and use cases.
typedef Result<T> = Either<Failure, T>;
typedef FutureResult<T> = Future<Result<T>>;

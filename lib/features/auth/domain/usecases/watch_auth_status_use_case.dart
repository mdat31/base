import 'package:injectable/injectable.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/auth/domain/entities/auth_status.dart';
import 'package:mod/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class WatchAuthStatusUseCase implements StreamUseCase<AuthStatus, NoParams> {
  const WatchAuthStatusUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Stream<AuthStatus> call(NoParams params) => _repository.watchStatus();
}

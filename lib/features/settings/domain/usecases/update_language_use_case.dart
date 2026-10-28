import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/settings/domain/repositories/settings_repository.dart';

/// Pass `null` to follow the device language.
@lazySingleton
class UpdateLanguageUseCase implements UseCase<Unit, String?> {
  const UpdateLanguageUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  FutureResult<Unit> call(String? params) =>
      _repository.saveLanguageCode(params);
}

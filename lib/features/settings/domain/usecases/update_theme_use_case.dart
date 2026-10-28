import 'package:injectable/injectable.dart';
import 'package:mod/core/error/result.dart';
import 'package:mod/core/usecase/usecase.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';
import 'package:mod/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class UpdateThemeUseCase implements UseCase<Unit, ThemePreference> {
  const UpdateThemeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  FutureResult<Unit> call(ThemePreference params) =>
      _repository.saveThemePreference(params);
}

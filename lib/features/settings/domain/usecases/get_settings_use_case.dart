import 'package:injectable/injectable.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  AppSettings call() => _repository.getSettings();
}

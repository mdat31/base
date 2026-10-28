import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mod/features/settings/domain/entities/app_settings.dart';
import 'package:mod/features/settings/domain/entities/theme_preference.dart';
import 'package:mod/features/settings/domain/usecases/get_settings_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_language_use_case.dart';
import 'package:mod/features/settings/domain/usecases/update_theme_use_case.dart';

part 'settings_cubit.freezed.dart';
part 'settings_state.dart';

/// App-wide theme and locale. Updates are optimistic and rolled back when
/// persisting fails.
@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    GetSettingsUseCase getSettings,
    this._updateTheme,
    this._updateLanguage,
  ) : super(SettingsState.fromSettings(getSettings()));

  final UpdateThemeUseCase _updateTheme;
  final UpdateLanguageUseCase _updateLanguage;

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    if (themeMode == state.themeMode) return;
    final previous = state;
    emit(state.copyWith(themeMode: themeMode));
    final result = await _updateTheme(themeMode.toPreference());
    if (result.isLeft() && !isClosed) emit(previous);
  }

  Future<void> changeLocale(Locale? locale) async {
    if (locale == state.locale) return;
    final previous = state;
    emit(state.copyWith(locale: locale));
    final result = await _updateLanguage(locale?.languageCode);
    if (result.isLeft() && !isClosed) emit(previous);
  }
}

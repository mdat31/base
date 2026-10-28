import 'package:bloc/bloc.dart';
import 'package:mod/core/logging/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._logger);

  final AppLogger _logger;

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    _logger.debug('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error('${bloc.runtimeType} failed', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

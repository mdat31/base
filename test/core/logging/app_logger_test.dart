import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/logging/app_bloc_observer.dart';
import 'package:mod/core/logging/app_logger.dart';

class _CounterCubit extends Cubit<int> {
  _CounterCubit() : super(0);

  void increment() => emit(state + 1);

  void fail() => addError(StateError('fail'));
}

void main() {
  test('logger methods never throw', () {
    for (final logger in const [
      AppLogger(enabled: true),
      AppLogger(enabled: false),
    ]) {
      expect(() {
        logger
          ..debug('debug')
          ..info('info')
          ..warning('warning', Exception('w'))
          ..error('error', Exception('e'), StackTrace.current);
      }, returnsNormally);
    }
  });

  test('bloc observer logs changes and errors', () async {
    Bloc.observer = const AppBlocObserver(AppLogger(enabled: true));
    final cubit = _CounterCubit()
      ..increment()
      ..fail();

    expect(cubit.state, 1);
    await cubit.close();
  });
}

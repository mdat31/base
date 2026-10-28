import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mod/app/router/stream_listenable.dart';

void main() {
  test('notifies listeners on every stream event', () async {
    final controller = StreamController<int>();
    final listenable = StreamListenable(controller.stream);
    var notifications = 0;
    listenable.addListener(() => notifications++);

    controller
      ..add(1)
      ..add(2);
    await pumpEventQueue();

    expect(notifications, 2);
    listenable.dispose();
    await controller.close();
  });
}

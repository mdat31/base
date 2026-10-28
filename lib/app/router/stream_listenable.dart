import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Stream] to the [Listenable] GoRouter uses for `refreshListenable`.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

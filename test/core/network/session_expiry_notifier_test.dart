import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/network/session_expiry_notifier.dart';

void main() {
  test('broadcasts expiry and ignores events after dispose', () async {
    final notifier = SessionExpiryNotifier();
    final events = <void>[];
    final subscription = notifier.onExpired.listen(events.add);

    notifier.notifyExpired();
    await Future<void>.delayed(Duration.zero);
    expect(events, hasLength(1));

    await subscription.cancel();
    await notifier.dispose();
    expect(notifier.notifyExpired, returnsNormally);
  });
}

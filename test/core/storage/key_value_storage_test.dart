import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/storage/key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reads, writes and removes strings', () async {
    SharedPreferences.setMockInitialValues({'existing': 'value'});
    final storage = SharedPreferencesStorage(
      await SharedPreferences.getInstance(),
    );

    expect(storage.getString('existing'), 'value');

    await storage.setString('key', 'new');
    expect(storage.getString('key'), 'new');

    await storage.remove('key');
    expect(storage.getString('key'), isNull);
  });
}

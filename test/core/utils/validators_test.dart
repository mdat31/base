import 'package:flutter_test/flutter_test.dart';
import 'package:mod/core/utils/validators.dart';

void main() {
  test('required', () {
    final validate = Validators.required('req');
    expect(validate(null), 'req');
    expect(validate('  '), 'req');
    expect(validate('a'), isNull);
  });

  test('minLength', () {
    final validate = Validators.minLength(3, 'short');
    expect(validate(null), 'short');
    expect(validate('ab'), 'short');
    expect(validate('abc'), isNull);
  });

  test('email', () {
    final validate = Validators.email('bad');
    expect(validate('nope'), 'bad');
    expect(validate(' a@b.co '), isNull);
  });

  test('compose returns the first error', () {
    final validate = Validators.compose([
      Validators.required('req'),
      Validators.email('bad'),
    ]);
    expect(validate(''), 'req');
    expect(validate('x'), 'bad');
    expect(validate('x@y.z'), isNull);
  });
}

typedef Validator = String? Function(String? value);

/// Composable form validators. Messages come from the caller so this stays
/// free of localization concerns.
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static Validator required(String message) =>
      (value) => value == null || value.trim().isEmpty ? message : null;

  static Validator minLength(int length, String message) =>
      (value) => (value ?? '').length < length ? message : null;

  static Validator email(String message) =>
      (value) => _emailPattern.hasMatch(value?.trim() ?? '') ? null : message;

  /// Returns the first error from [validators], or `null` when all pass.
  static Validator compose(List<Validator> validators) => (value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  };
}

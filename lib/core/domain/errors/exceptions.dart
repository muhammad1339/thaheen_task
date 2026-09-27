/// A startup failure the user can recover from by retrying, such as local
/// storage being temporarily unavailable. Anything else thrown during
/// bootstrap is treated as a bug.
class ThaheenStartupException implements Exception {
  const ThaheenStartupException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'ThaheenStartupException: $message'
      : 'ThaheenStartupException: $message ($cause)';
}

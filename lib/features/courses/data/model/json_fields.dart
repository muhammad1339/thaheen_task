/// Typed, validated field reads for hand-written `fromJson` constructors.
/// Every failure is a [FormatException] naming the offending key.
extension JsonFields on Map<String, dynamic> {
  String requireString(String key) {
    final value = this[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw FormatException('"$key" must be a non-empty string');
  }

  int requirePositiveInt(String key) {
    final value = this[key];
    if (value is int && value > 0) return value;
    throw FormatException('"$key" must be a positive integer');
  }

  /// Maps each object in the list at [key] with [fromJson].
  List<T> requireList<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final value = this[key];
    if (value is! List) throw FormatException('"$key" must be a list');
    return [
      for (final item in value)
        if (item is Map<String, dynamic>)
          fromJson(item)
        else
          throw FormatException('Items of "$key" must be objects'),
    ];
  }
}

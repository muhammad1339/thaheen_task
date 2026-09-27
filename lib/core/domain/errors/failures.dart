enum FailureType { storage, invalidData, notFound, media }

class Failure {
  const Failure(this.type);
  final FailureType type;

  @override
  String toString() => 'Failure(${type.name})';
}

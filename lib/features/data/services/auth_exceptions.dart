class ExpectedFailureException implements Exception {
  final String message;

  ExpectedFailureException(this.message);

  @override
  String toString() {
    return message;
  }
}


class InternalFailureException implements Exception {
  final String message;

  InternalFailureException(this.message);

  @override
  String toString() {
    return "InternalFailureException: $message";
  }
}





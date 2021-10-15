class ConnectionLostException implements Exception {
  final String cause;
  ConnectionLostException({
    required this.cause,
  });
}

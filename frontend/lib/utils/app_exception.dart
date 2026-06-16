class AppException implements Exception {
  final String code;
  final String message;
  final bool isRetryable;

  AppException({
    required this.code,
    required this.message,
    this.isRetryable = false,
  });

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class NetworkException extends AppException {
  NetworkException({required String message})
      : super(code: 'NETWORK_ERROR', message: message, isRetryable: true);
}

class AuthException extends AppException {
  AuthException({required String message})
      : super(code: 'AUTH_ERROR', message: message, isRetryable: false);
}

class ServerException extends AppException {
  ServerException({required String message})
      : super(code: 'SERVER_ERROR', message: message, isRetryable: true);
}

class TimeoutException extends AppException {
  TimeoutException({required String message})
      : super(code: 'TIMEOUT_ERROR', message: message, isRetryable: true);
}

class ValidationException extends AppException {
  ValidationException({required String message})
      : super(code: 'VALIDATION_ERROR', message: message, isRetryable: false);
}

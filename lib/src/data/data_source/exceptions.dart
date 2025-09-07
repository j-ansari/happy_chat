class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException{code: \$code, message: \$message}';
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message) : super(message, 401);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class ApiException extends AppException {
  ApiException(super.message, [super.code]);
}

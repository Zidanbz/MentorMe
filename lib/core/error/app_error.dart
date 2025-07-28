abstract class AppError {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppError: $message';
}

class NetworkError extends AppError {
  const NetworkError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ServerError extends AppError {
  final int? statusCode;

  const ServerError({
    required super.message,
    this.statusCode,
    super.code,
    super.originalError,
  });
}

class AuthenticationError extends AppError {
  const AuthenticationError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ValidationError extends AppError {
  final Map<String, String>? fieldErrors;

  const ValidationError({
    required super.message,
    this.fieldErrors,
    super.code,
    super.originalError,
  });
}

class CacheError extends AppError {
  const CacheError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class UnknownError extends AppError {
  const UnknownError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class RegistrationException implements Exception {
  final String message;

  RegistrationException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}

class ClientTimeoutException implements Exception {
  final String message;

  ClientTimeoutException(this.message);
}

class RequestTimeoutException implements Exception {
  final String message;

  RequestTimeoutException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;

  InternalServerErrorException(this.message);
}

class NotImplementedException implements Exception {
  final String message;

  NotImplementedException(this.message);
}

class ServiceUnavailableException implements Exception {
  final String message;

  ServiceUnavailableException(this.message);
}

class ConflictException implements Exception {
  final String message;

  ConflictException(this.message);
}

class UnprocessableEntityException implements Exception {
  final String message;

  UnprocessableEntityException(this.message);
}

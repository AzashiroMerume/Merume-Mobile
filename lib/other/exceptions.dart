class TokenErrorException implements Exception {
  final String message;

  TokenErrorException(this.message);
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);
}

class FirebaseAuthenticationException implements Exception {
  final String message;

  FirebaseAuthenticationException(this.message);
}

class PreferencesUnsetException implements Exception {
  final String message;

  PreferencesUnsetException(this.message);
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

class UnprocessableEntityException implements Exception {
  final String message;

  UnprocessableEntityException(this.message);
}

class ContentTooLargeException implements Exception {
  final String message;

  ContentTooLargeException(this.message);
}

class PostAuthorConflictException implements Exception {
  final String message;

  PostAuthorConflictException(this.message);
}

class FirebaseUploadException implements Exception {
  final String message;

  FirebaseUploadException(this.message);
}

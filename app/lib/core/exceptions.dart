/// Custom exception types for the app
abstract class AppException implements Exception {
  const AppException(this.message, this.code);

  final String message;
  final String code;

  @override
  String toString() => 'AppException($code): $message';
}

/// Authentication related errors
class AuthException extends AppException {
  const AuthException(super.message, super.code);

  factory AuthException.userNotFound() =>
      const AuthException('User not found', 'user-not-found');

  factory AuthException.invalidCredentials() =>
      const AuthException('Invalid credentials', 'invalid-credentials');

  factory AuthException.networkError() => const AuthException(
      'Network error during authentication', 'network-error');

  factory AuthException.signInCancelled() =>
      const AuthException('Sign in was cancelled', 'sign-in-cancelled');
}

/// Game related errors
class GameException extends AppException {
  const GameException(super.message, super.code);

  factory GameException.dailyNotFound(String date) =>
      GameException('Daily puzzle not found for $date', 'daily-not-found');

  factory GameException.invalidAttempt() =>
      const GameException('Invalid attempt submitted', 'invalid-attempt');

  factory GameException.gameAlreadyCompleted() =>
      const GameException('Game already completed', 'game-completed');

  factory GameException.tooManyAttempts() =>
      const GameException('Maximum attempts exceeded', 'too-many-attempts');

  factory GameException.insufficientPoints() => const GameException(
      'Insufficient points for hint', 'insufficient-points');
}

/// Network related errors
class NetworkException extends AppException {
  const NetworkException(super.message, super.code);

  factory NetworkException.noConnection() =>
      const NetworkException('No internet connection', 'no-connection');

  factory NetworkException.timeout() =>
      const NetworkException('Request timeout', 'timeout');

  factory NetworkException.serverError() =>
      const NetworkException('Server error', 'server-error');

  factory NetworkException.rateLimited() =>
      const NetworkException('Rate limit exceeded', 'rate-limited');
}

/// Data related errors
class DataException extends AppException {
  const DataException(super.message, super.code);

  factory DataException.notFound(String item) =>
      DataException('$item not found', 'not-found');

  factory DataException.parseError() =>
      const DataException('Failed to parse data', 'parse-error');

  factory DataException.cacheError() =>
      const DataException('Cache operation failed', 'cache-error');

  factory DataException.syncError() =>
      const DataException('Data synchronization failed', 'sync-error');
}

/// Security related errors
class SecurityException extends AppException {
  const SecurityException(super.message, super.code);

  factory SecurityException.invalidReceipt() =>
      const SecurityException('Invalid score receipt', 'invalid-receipt');

  factory SecurityException.appCheckFailed() => const SecurityException(
      'App Check verification failed', 'app-check-failed');

  factory SecurityException.rateLimitExceeded() =>
      const SecurityException('Rate limit exceeded', 'rate-limit-exceeded');

  factory SecurityException.suspiciousActivity() => const SecurityException(
      'Suspicious activity detected', 'suspicious-activity');
}

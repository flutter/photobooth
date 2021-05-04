import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Thrown when signing in anonymously process fails.
class SignInAnonymouslyException implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication using Firebase Authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  const AuthenticationRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Logs in into the app as an anonymous user.
  ///
  /// Throws [SignInAnonymouslyException] when operation fails.
  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } catch (_) {
      throw SignInAnonymouslyException();
    }
  }
}

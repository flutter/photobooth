import 'package:authentication_repository/authentication_repository.dart';
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

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => user == null ? User.none : user.toUser);
  }

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

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid);
  }
}

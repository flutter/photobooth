// ignore_for_file: must_be_immutable
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

void main() {
  group('AuthenticationRepository', () {
    late firebase_auth.FirebaseAuth firebaseAuth;
    late AuthenticationRepository authenticationRepository;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
    });

    setUp(() {
      firebaseAuth = MockFirebaseAuth();

      authenticationRepository = AuthenticationRepository(
        firebaseAuth: firebaseAuth,
      );
    });

    group('signInAnonymously', () {
      setUp(() {
        when(
          () => firebaseAuth.signInAnonymously(),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signInAnonymously', () async {
        await authenticationRepository.signInAnonymously();
        verify(
          () => firebaseAuth.signInAnonymously(),
        ).called(1);
      });

      test('succeeds when signInAnonymously succeeds', () async {
        expect(
          authenticationRepository.signInAnonymously(),
          completes,
        );
      });

      test(
          'throws SignInAnonymouslyException '
          'when signInAnonymously throws', () async {
        when(
          () => firebaseAuth.signInAnonymously(),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.signInAnonymously(),
          throwsA(isA<SignInAnonymouslyException>()),
        );
      });
    });
  });
}

// ignore_for_file: must_be_immutable
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

const _mockFirebaseUserUid = 'mock-uid';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {
  @override
  String get uid => _mockFirebaseUserUid;
}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

void main() {
  const user = User(id: _mockFirebaseUserUid);

  group('AuthenticationRepository', () {
    late firebase_auth.FirebaseAuth firebaseAuth;
    late AuthenticationRepository authenticationRepository;

    setUpAll(() {
      registerFallbackValue<firebase_auth.AuthCredential>(FakeAuthCredential());
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

    group('user', () {
      test('emits none user when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[User.none]),
        );
      });

      test('emits User when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(firebaseUser));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[user]),
        );
      });
    });
  });
}

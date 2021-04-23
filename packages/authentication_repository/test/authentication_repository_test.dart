// ignore_for_file: must_be_immutable
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();
  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': const <String, String>{},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      final arguments = call.arguments as Map<String, dynamic>;
      return <String, dynamic>{
        'name': arguments['appName'],
        'options': arguments['options'],
        'pluginConstants': const <String, String>{},
      };
    }

    return null;
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

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
      test('does not emit user when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <User>[]),
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

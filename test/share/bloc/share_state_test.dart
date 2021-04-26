// ignore_for_file: prefer_const_constructors
//
import 'package:io_photobooth/share/share.dart';
import 'package:test/test.dart';

void main() {
  group('ShareState', () {
    group('initial', () {
      test('supports value equality', () {
        expect(ShareState.initial(), equals(ShareState.initial()));
      });

      test('status is initial', () {
        expect(
          ShareState.initial().status,
          ShareStatus.initial,
        );
      });
    });

    group('loading', () {
      test('supports value equality', () {
        expect(ShareState.loading(), equals(ShareState.loading()));
      });

      test('status is loading', () {
        expect(
          ShareState.loading().status,
          ShareStatus.loading,
        );
      });
    });

    group('success', () {
      test('supports value equality', () {
        expect(ShareState.success(), equals(ShareState.success()));
      });

      test('status is success', () {
        expect(
          ShareState.success().status,
          ShareStatus.success,
        );
      });
    });

    group('error', () {
      test('supports value equality', () {
        expect(ShareState.error(), equals(ShareState.error()));
      });

      test('status is error', () {
        expect(
          ShareState.error().status,
          ShareStatus.error,
        );
      });
    });
  });
}

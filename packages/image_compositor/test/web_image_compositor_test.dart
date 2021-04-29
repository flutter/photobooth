@TestOn('chrome')

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:image_compositor/src/web.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/helpers.dart';

class MockWorker extends Mock implements Worker {}

class MockMessageEvent extends Mock implements MessageEvent {}

class MockUint8List extends Mock implements Uint8List {}

void main() {
  final data = 'data:image/png,${base64.encode(transparentImage)}';
  const width = 4;
  const height = 4;
  const layers = [];
  const aspectRatio = 4 / 3;
  final buffer = Uint8List.fromList(transparentImage).buffer;

  group('ImageCompositor', () {
    test('can be instantiated without an explicit worker', () {
      expect(ImageCompositor(), isNotNull);
    });

    group('composite', () {
      late Uint8List bytes = MockUint8List();
      late Worker worker;
      late ImageCompositor compositor;

      setUp(() {
        worker = MockWorker();
        compositor = ImageCompositor(
          worker: worker,
          request: (_) async => bytes,
        );

        when(() => bytes.buffer).thenReturn(buffer);
        when(() => worker.postMessage(any(), any())).thenReturn(null);
      });

      test('returns message from worker when complete', () async {
        const result = <int>[];
        final event = MockMessageEvent();

        when(() => event.data).thenReturn(result);
        when(() => worker.onMessage).thenAnswer((_) => Stream.value(event));

        final actual = await compositor.composite(
          data: data,
          width: width,
          height: height,
          layers: layers,
          aspectRatio: aspectRatio,
        );

        expect(actual, equals(result));

        verify(
          () => worker.postMessage(
            [buffer, width, height, layers, aspectRatio],
            [buffer],
          ),
        ).called(1);
      });
    });
  });
}

@TestOn('chrome')

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:test/test.dart';
import 'package:image_compositor/src/web.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/helpers.dart';

class MockWorker extends Mock implements Worker {}

class MockMessageEvent extends Mock implements MessageEvent {}

void main() {
  final data = 'data:image/png,${base64.encode(transparentImage)}';
  const width = 4;
  const height = 4;
  const layers = [];
  const aspectRatio = 4 / 3;

  group('ImageCompositor', () {
    test('can be instantiated without an explicit worker', () {
      expect(ImageCompositor(), isNotNull);
    });

    group('composite', () {
      late Worker worker;
      late ImageCompositor compositor;

      setUp(() {
        worker = MockWorker();
        compositor = ImageCompositor(worker: worker);

        when(() => worker.postMessage(any())).thenReturn(null);
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
          () => worker.postMessage([data, width, height, layers, aspectRatio]),
        ).called(1);
      });
    });
  });
}

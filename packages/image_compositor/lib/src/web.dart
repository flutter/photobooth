import 'dart:async';
import 'dart:html';
// import 'offscreen_compositor.dart';

/// {@template image_compositor}
/// Web Implementation of [ImageCompositor]
/// @{endtemplate}
class ImageCompositor {
  /// {@macro image_compositor}
  ImageCompositor({Worker? worker})
      : _worker = worker ?? Worker('image_compositor.js');

  final Worker _worker;

  /// Composites the [data] and [layers] via a [Worker]
  /// and returns a byte array with the provided [aspectRatio].
  Future<List<int>> composite({
    required String data,
    required int width,
    required int height,
    required List layers,
    required double aspectRatio,
  }) {
    final completer = Completer<List<int>>();
    _worker.onMessage.first.then(
      (e) => completer.complete(e.data),
      onError: (e) => completer.completeError(e),
    );
    _worker.postMessage([data, width, height, layers, aspectRatio]);
    return completer.future;

    // Move compositior files to src and then switch to code below:
    // final compositor = OffscreenCompositor(data, width, height, layers,
    //    aspectRatio);
    // return compositor.composite();
  }
}

import 'dart:async';
import 'dart:html';

/// Web Implementation of [ImageCompositor]
class ImageCompositor {
  ImageCompositor({Worker? worker})
      : _worker = worker ?? Worker('image_compositor.js');

  final Worker _worker;

  Future<List<int>> composite({
    required String data,
    required int width,
    required int height,
    required List layers,
  }) {
    print('composite()');
    final completer = Completer<List<int>>();
    _worker.onMessage.first.then(
      (e) => completer.complete(e.data),
      onError: (e) => completer.completeError(e),
    );
    _worker.postMessage([data, width, height, layers]);
    return completer.future;
  }
}

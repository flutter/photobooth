import 'dart:async';
import 'dart:html';

/// Web Implementation of [ImageCompositor]

class ImageCompositor {
  ImageCompositor({Worker? worker})
      : _worker = worker ?? Worker('image_compositor.js');

  final Worker _worker;

  Future<String> composite() {
    print('composite()');
    final completer = Completer<String>();
    _worker.onMessage.first.then(
      (e) => completer.complete('Hello'),
      onError: (e) => completer.completeError(e),
    );
    print('postMessage!');
    _worker.postMessage('message', null);
    return completer.future;
  }
}

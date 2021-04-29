import 'dart:async';
import 'dart:html';

import 'dart:typed_data';

/// Signature for request made by the compositor to fetch image bytes
/// before transfering them to the worker.
typedef RequestBytes = Future<Uint8List> Function(String);

/// {@template image_compositor}
/// Web Implementation of [ImageCompositor]
/// @{endtemplate}
class ImageCompositor {
  /// {@macro image_compositor}
  ImageCompositor({Worker? worker, RequestBytes? request})
      : _worker = worker ?? Worker('image_compositor.js'),
        _request = request ?? _getBytes;

  final Worker _worker;
  final RequestBytes _request;

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
    _request(data).then((bytes) {
      _worker.postMessage(
        [bytes.buffer, width, height, layers, aspectRatio],
        [bytes.buffer],
      );
    }, onError: (e) => completer.completeError(e));
    return completer.future;
  }
}

Future<Uint8List> _getBytes(String path) async {
  final ByteBuffer? response =
      (await HttpRequest.request(path, responseType: 'arraybuffer')).response;

  return response?.asUint8List() ?? Uint8List(0);
}

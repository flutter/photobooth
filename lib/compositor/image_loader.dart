import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'package:pedantic/pedantic.dart' show unawaited;

final bool _supportsDecode = js_util.getProperty(
        js_util.getProperty(
            js_util.getProperty(html.window, 'Image'), 'prototype'),
        'decode') !=
    null;

typedef WebOnlyImageCodecChunkCallback = void Function(
    int cumulativeBytesLoaded, int expectedTotalBytes);

class HtmlImage {
  HtmlImage(this.imageElement, this.width, this.height);

  final html.ImageElement imageElement;
  final int width;
  final int height;
}

class HtmlImageLoader {
  HtmlImageLoader(this.src);

  final String src;

  Future<HtmlImage> loadImage() async {
    final completer = Completer<HtmlImage>();
    if (_supportsDecode) {
      final imgElement = html.ImageElement()..src = src;
      js_util.setProperty(imgElement, 'decoding', 'async');
      unawaited(imgElement.decode().then((dynamic _) {
        var naturalWidth = imgElement.naturalWidth;
        var naturalHeight = imgElement.naturalHeight;
        // Workaround for https://bugzilla.mozilla.org/show_bug.cgi?id=700533.
        if (naturalWidth == 0 && naturalHeight == 0) {
          const kDefaultImageSizeFallback = 300;
          naturalWidth = kDefaultImageSizeFallback;
          naturalHeight = kDefaultImageSizeFallback;
        }
        final image = HtmlImage(
          imgElement,
          naturalWidth,
          naturalHeight,
        );
        completer.complete(image);
      }).catchError((dynamic e) {
        // This code path is hit on Chrome 80.0.3987.16 when too many
        // images are on the page (~1000).
        // Fallback here is to load using onLoad instead.
        _decodeUsingOnLoad(completer);
      }));
    } else {
      _decodeUsingOnLoad(completer);
    }
    return completer.future;
  }

  void _decodeUsingOnLoad(Completer completer) {
    StreamSubscription<html.Event>? loadSubscription;
    late StreamSubscription<html.Event> errorSubscription;
    final imgElement = html.ImageElement();
    // If the browser doesn't support asynchronous decoding of an image,
    // then use the `onload` event to decide when it's ready to paint to the
    // DOM. Unfortunately, this will cause the image to be decoded synchronously
    // on the main thread, and may cause dropped framed.
    errorSubscription = imgElement.onError.listen((html.Event event) {
      loadSubscription?.cancel();
      errorSubscription.cancel();
      completer.completeError(event);
    });
    loadSubscription = imgElement.onLoad.listen((html.Event event) {
      loadSubscription!.cancel();
      errorSubscription.cancel();
      final image = HtmlImage(
        imgElement,
        imgElement.naturalWidth,
        imgElement.naturalHeight,
      );
      completer.complete(image);
    });
    imgElement.src = src;
  }
}

/// A web worker which handles image compositing.
/// To compile to js use `dart2js` by running the following command
/// from within the `tool` directory
///
/// `dart2js -m -o ../web/image_compositor.js image_compositor.dart`
///
@JS()
library image_compositor;

import 'dart:html';
import 'package:js/js.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) {
    print('Message received: ${e.data}');
    print('Posting Message!');
    self.postMessage('Hello!', null);
  });
}

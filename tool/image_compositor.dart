/// A web worker which handles image compositing.
/// To compile to js use `dart2js` by running the following command
/// from within the `tool` directory
///
/// `dart2js -m -o ../web/image_compositor.js image_compositor.dart`
///
@JS()
library image_compositor;

import 'dart:async';
import 'dart:html';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image_compositor/image_compositor.dart';
import 'package:js/js.dart';
import 'package:image/image.dart' as img;

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) {
    final data = e.data;
    if (data is List && data.isNotEmpty) {
      _composite(
        data: data[0],
        width: data[1],
        height: data[2],
        rawLayers: data[3],
      ).then((result) {
        self.postMessage(result, null);
      }).catchError((error, stackTrace) {
        print('error $error, stackTrace $stackTrace');
      });
    }
  });
}

Future<List<int>> _composite({
  required int width,
  required int height,
  required String data,
  required List rawLayers,
  double aspectRatio = 4 / 3,
}) async {
  print('_composite()');
  final completer = Completer<List<int>>();

  final bytes = await getBytes(data);
  final image = img.decodePng(bytes)!;

  final inputImageAspectRatio = width / height;

  var croppedWidth = width.toDouble();
  var croppedHeight = height.toDouble();

  if (inputImageAspectRatio > aspectRatio) {
    croppedWidth = height * aspectRatio;
  } else if (inputImageAspectRatio < aspectRatio) {
    croppedHeight = width / aspectRatio;
  }

  final croppedDx = ((croppedWidth - width) / 2).abs().round();
  final croppedDy = ((croppedHeight - height) / 2).abs().round();
  var croppedImage = img.copyCrop(
    image,
    croppedDx,
    croppedDy,
    croppedWidth.round(),
    croppedHeight.round(),
  );

  final layers =
      rawLayers.map((l) => CompositeLayer.fromJson(l as Map)).toList();
  for (final layer in layers) {
    print('asset: ${layer.assetPath}');
    final assetBytes = await getBytes(layer.assetPath);
    final asset = img.decodePng(assetBytes)!;
    final rotatedAsset = img.copyRotate(asset, layer.angle * (180 / math.pi));
    croppedImage = img.drawImage(
      croppedImage,
      rotatedAsset,
      dstX: layer.position.x.round(),
      dstY: layer.position.y.round(),
      dstW: (layer.size.x * layer.scale).round(),
      dstH: (layer.size.y * layer.scale).round(),
    );
  }

  final frameAssetPath = aspectRatio == 3 / 4
      ? 'assets/assets/images/photo_frame_mobile.png'
      : 'assets/assets/images/photo_frame.png';
  final frameBytes = await getBytes(frameAssetPath);
  final frame = img.decodePng(frameBytes)!;

  final framedImage = img.drawImage(
    frame,
    croppedImage,
    dstX: ((frame.width / 2) - (croppedWidth / 2) + 27).round(),
    dstY: ((frame.height / 2) - (croppedHeight / 2)).round(),
  );

  completer.complete(img.encodePng(framedImage));

  return completer.future;
}

Future<Uint8List> getBytes(String path) async {
  // We can force 'response' to be a byte buffer by passing responseType:
  final ByteBuffer? response =
      (await HttpRequest.request(path, responseType: 'arraybuffer')).response;

  return response?.asUint8List() ?? Uint8List(0);
}

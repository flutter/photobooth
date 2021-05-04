/// A web worker which handles image compositing.
/// To compile to js use `dart2js` by running the following command
/// from within the `tool` directory
///
/// `dart2js -m -o ../web/image_compositor.js image_compositor.dart`
///
@JS()
library image_compositor;

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
    if (data is List && data.length == 5) {
      _composite(
        data: data[0],
        width: data[1],
        height: data[2],
        rawLayers: data[3],
        aspectRatio: data[4],
      ).then((result) {
        self.postMessage(result, null);
      }).catchError((error, stackTrace) {
        print('error $error, stackTrace $stackTrace');
      });
    }
  });
}

const _frameBorderSize = 8;
const _frameHorizontalPadding = 16;

Future<List<int>> _composite({
  required int width,
  required int height,
  required String data,
  required List rawLayers,
  required double aspectRatio,
}) async {
  final bytes = await getBytes(data);
  var image = img.decodePng(bytes)!;

  final inputImageAspectRatio = width / height;

  var croppedWidth = width.toDouble();
  var croppedHeight = height.toDouble();

  if (inputImageAspectRatio > aspectRatio) {
    croppedWidth = height * aspectRatio;
  } else if (inputImageAspectRatio < aspectRatio) {
    croppedHeight = width / aspectRatio;
  }

  final croppedDx = ((croppedWidth - width) ~/ 2).abs();
  final croppedDy = ((croppedHeight - height) ~/ 2).abs();
  image = img.copyCrop(
    image,
    croppedDx,
    croppedDy,
    croppedWidth.round(),
    croppedHeight.round(),
  );

  final layers =
      rawLayers.map((l) => CompositeLayer.fromJson(l as Map)).toList();
  for (final layer in layers) {
    final assetBytes = await getBytes(layer.assetPath);
    var asset = img.decodePng(assetBytes)!;

    final widthFactor = image.width / layer.constraints.x;
    final heightFactor = image.height / layer.constraints.y;

    final assetWidth = (layer.size.x * widthFactor * layer.scale).round();
    final assetDx = ((layer.position.x * widthFactor * layer.scale)).round();
    final assetDy = (layer.position.y * heightFactor * layer.scale).round();

    if (layer.angle != 0)
      asset = img.copyRotate(
        asset,
        layer.angle * (180 / math.pi),
        interpolation: img.Interpolation.average,
      );

    if (asset.width != assetWidth)
      asset = img.copyResize(asset, width: assetWidth);

    image = img.drawImage(image, asset, dstX: assetDx, dstY: assetDy);
  }

  final frameAssetPath = aspectRatio == 3 / 4
      ? 'assets/assets/images/photo_frame_mobile_download.png'
      : 'assets/assets/images/photo_frame_download.png';
  final frameBytes = await getBytes(frameAssetPath);
  var frame = img.decodePng(frameBytes)!;

  if (frame.width > croppedWidth) {
    frame = img.copyResize(
      frame,
      width: (croppedWidth + _frameHorizontalPadding).round(),
      interpolation: img.Interpolation.cubic,
    );
  }

  final framedImageWidth = frame.width - _frameHorizontalPadding;
  image = img.drawImage(
    frame,
    image,
    dstX: _frameBorderSize,
    dstY: _frameBorderSize,
    dstW: framedImageWidth,
    dstH: (framedImageWidth / aspectRatio).round(),
  );

  return img.encodeJpg(image);
}

Future<Uint8List> getBytes(String path) async {
  final Body response = await self.fetch(path);
  final ByteBuffer? buffer = await response.arrayBuffer();
  return buffer?.asUint8List() ?? Uint8List(0);
}

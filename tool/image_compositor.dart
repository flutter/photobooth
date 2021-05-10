/// A web worker which handles image compositing.
/// To compile to js use `dart2js` by running the following command
/// from within the `tool` directory
///
/// `dart2js -m -O4 -o ../web/image_compositor.js image_compositor.dart`
///
@JS()
library image_compositor;

import 'dart:html';
// import 'dart:math' as math;
// import 'dart:typed_data';
//
// import 'package:image/image.dart' as img;
// import 'package:image_compositor/image_compositor.dart';
import 'package:js/js.dart';

import 'compositor/offscreen_compositor.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() {
  self.onMessage.listen((e) {
    final data = e.data;
    if (data is List && data.length == 5) {
      // Alternative impl using image package.
      // _composite(
      //   data: data[0],
      //   width: data[1],
      //   height: data[2],
      //   rawLayers: data[3],
      //   aspectRatio: data[4],
      //
      // ).then((result) {
      OffscreenCompositor(data[0], data[1], data[2], data[3], data[4])
          .composite()
          .then((result) {
        self.postMessage(result, null);
      }).catchError((error, stackTrace) {
        print('error $error, stackTrace $stackTrace');
      });
    }
  });
}

// Alternative worker implementation based on image package.
//
// const _frameBorderSize = 8;
// const _frameHorizontalPadding = 16;
//
// Future<List<int>> _composite({
//   required int width,
//   required int height,
//   required String data,
//   required List rawLayers,
//   required double aspectRatio,
// }) async {
//   final bytes = await getBytes(data);
//   var image = img.decodePng(bytes)!;
//
//   final inputImageAspectRatio = width / height;
//
//   var croppedWidth = width.toDouble();
//   var croppedHeight = height.toDouble();
//
//   if (inputImageAspectRatio > aspectRatio) {
//     croppedWidth = height * aspectRatio;
//   } else if (inputImageAspectRatio < aspectRatio) {
//     croppedHeight = width / aspectRatio;
//   }
//
//   final croppedDx = ((croppedWidth - width) ~/ 2).abs();
//   final croppedDy = ((croppedHeight - height) ~/ 2).abs();
//   image = img.copyCrop(
//     image,
//     croppedDx,
//     croppedDy,
//     croppedWidth.round(),
//     croppedHeight.round(),
//   );
//
//   final layers =
//       rawLayers.map((l) => CompositeLayer.fromJson(l as Map)).toList();
//   for (final layer in layers) {
//     final assetBytes = await getBytes(layer.assetPath);
//     var asset = img.decodePng(assetBytes)!;
//
//     final widthFactor = image.width / layer.constraints.x;
//     final heightFactor = image.height / layer.constraints.y;
//
//     final assetWidth = (layer.size.x * widthFactor).round();
//     final assetDx = ((layer.position.x * widthFactor)).round();
//     final assetDy = (layer.position.y * heightFactor).round();
//
//     if (asset.width != assetWidth)
//       asset = img.copyResize(
//         asset,
//         width: assetWidth,
//         interpolation: img.Interpolation.cubic,
//       );
//
//     var rotationOffset = const Vector2D(0, 0);
//     if (layer.angle != 0) {
//       final oldWidth = asset.width;
//       final oldHeight = asset.height;
//       asset = img.copyRotate(
//         asset,
//         layer.angle * (180 / math.pi),
//         interpolation: img.Interpolation.cubic,
//       );
//       final offsetX = (asset.width - oldWidth) / 2;
//       final offsetY = (asset.height - oldHeight) / 2;
//       rotationOffset = Vector2D(offsetX, offsetY);
//     }
//
//     image = img.drawImage(
//       image,
//       asset,
//       dstX: (assetDx - rotationOffset.x).round(),
//       dstY: (assetDy - rotationOffset.y).round(),
//       dstW: asset.width,
//       dstH: asset.height,
//     );
//   }
//
//   final frameAssetPath = aspectRatio < 1
//       ? 'assets/assets/images/photo_frame_mobile_download.png'
//       : 'assets/assets/images/photo_frame_download.png';
//   final frameBytes = await getBytes(frameAssetPath);
//   var frame = img.decodePng(frameBytes)!;
//
//   if (frame.width > croppedWidth) {
//     frame = img.copyResize(
//       frame,
//       width: (croppedWidth + _frameHorizontalPadding).round(),
//       interpolation: img.Interpolation.cubic,
//     );
//   }
//
//   final framedImageWidth = frame.width - _frameHorizontalPadding;
//   image = img.drawImage(
//     frame,
//     image,
//     dstX: _frameBorderSize,
//     dstY: _frameBorderSize,
//     dstW: framedImageWidth,
//     dstH: (framedImageWidth / aspectRatio).round(),
//   );
//
//   return img.encodeJpg(image);
// }
//
// Future<Uint8List> getBytes(String path) async {
//   final Body response = await self.fetch(path);
//   final ByteBuffer? buffer = await response.arrayBuffer();
//   return buffer?.asUint8List() ?? Uint8List(0);
// }

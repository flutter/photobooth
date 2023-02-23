import 'dart:async';
import 'dart:convert';

import 'package:image_compositor/image_compositor.dart';
import 'package:image_compositor/src/image_loader.dart';
import 'package:image_compositor/src/offscreen_canvas.dart';

/// {@macro image_compositor}
class ImageCompositor {
  /// {@macro image_compositor}
  ImageCompositor();

  /// Composites the [data] and [layers]
  /// and returns a byte array with the provided [aspectRatio].
  Future<List<int>> composite({
    required String data,
    required int width,
    required int height,
    required List<dynamic> layers,
    required double aspectRatio,
  }) {
    return _OffscreenCompositor(data, width, height, layers, aspectRatio)
        .composite();
  }
}

class _OffscreenCompositor {
  const _OffscreenCompositor(
    this.data,
    this.width,
    this.height,
    this.rawLayers,
    this.targetAspectRatio,
  );

  final String data;
  final int width;
  final int height;
  final List<dynamic> rawLayers;
  final double targetAspectRatio;

  /// Left, Top, Right border size.
  static const _frameBorderSize = 15;

  Future<List<int>> composite() async {
    final layers =
        rawLayers.map((l) => CompositeLayer.fromJson(l as Map)).toList();

    final imageFutures = <Future<HtmlImage>>[];

    /// Load assets in parallel.
    final imageFuture = HtmlImageLoader(data).loadImage();
    for (var layerIndex = 0; layerIndex < layers.length; layerIndex++) {
      final imageFuture =
          HtmlImageLoader(layers[layerIndex].assetPath).loadImage();
      imageFutures.add(imageFuture);
    }

    /// Load framed image.
    await Future.wait(imageFutures);
    final image = await imageFuture;

    /// Prepare image elements.
    final frameAssetPath = targetAspectRatio < 1
        ? 'assets/assets/images/photo_frame_mobile_download.png'
        : 'assets/assets/images/photo_frame_download.png';
    final frameImage = await HtmlImageLoader(frameAssetPath).loadImage();

    /// Compute target coordinates and target image size from assets.
    final targetWidth = frameImage.width;
    final targetHeight = frameImage.height;

    /// We will have to create a clipping rectangle within frame and compute
    /// videoRect that will correct the aspectratio and crop the image
    /// correctly.
    final inputVideoAspectRatio = width / height;
    var croppedWidth = width.toDouble();
    var croppedHeight = height.toDouble();

    // Amount to shift drawing so that image gets cropped.
    var imageCropOffsetX = 0;
    var imageCropOffsetY = 0;
    if (inputVideoAspectRatio > targetAspectRatio) {
      // Crop left and right of video
      croppedWidth = height * targetAspectRatio;
      imageCropOffsetX = (croppedWidth - width) ~/ 2;
    } else {
      // Crop top and bottom of video
      croppedHeight = width / targetAspectRatio;
      imageCropOffsetY = (croppedHeight - height) ~/ 2;
    }

    const insideFrameX = _frameBorderSize;
    const insideFrameY = _frameBorderSize;
    final insideFrameWidth = frameImage.width - (2 * _frameBorderSize);
    final insideFrameHeight = insideFrameWidth ~/ targetAspectRatio;

    /// Render images to offscreen canvas.
    final canvas = OffScreenCanvas(targetWidth, targetHeight)

      /// Draw frame to cover full cropped area.
      ..drawImage(frameImage.imageElement, 0, 0, targetWidth, targetHeight)

      /// Clip to frame interior.
      ..clipRect(
        insideFrameX,
        insideFrameY,
        insideFrameWidth,
        insideFrameHeight,
      );

    /// Scale the image so the cropped portion will cover the inside of
    /// the frame.
    final imageScaleFactor = (inputVideoAspectRatio > targetAspectRatio)
        ? insideFrameHeight / image.height
        : insideFrameWidth / image.width;

    final videoImageX =
        insideFrameX + (imageCropOffsetX * imageScaleFactor).toInt();
    final videoImageY =
        insideFrameY + (imageCropOffsetY * imageScaleFactor).toInt();
    final videoImageWidth = (image.width * imageScaleFactor).toInt();
    final videoImageHeight = (image.height * imageScaleFactor).toInt();

    canvas.drawImage(
      image.imageElement,
      videoImageX,
      videoImageY,
      videoImageWidth,
      videoImageHeight,
    );

    for (var layerIndex = 0; layerIndex < layers.length; layerIndex++) {
      final layer = layers[layerIndex];
      final asset = await imageFutures[layerIndex];

      /// Normalize coordinates to 0..1 based on original video image size.
      /// then scale to target.
      final assetDxPercent = layer.position.x / layer.constraints.x;
      final assetDyPercent = layer.position.y / layer.constraints.y;
      final assetWidthPercent = layer.size.x / layer.constraints.x;
      final assetDx = assetDxPercent * insideFrameWidth;
      final assetDy = assetDyPercent * insideFrameHeight;
      final assetWidth = assetWidthPercent * insideFrameWidth;

      /// Keep aspect ratio of asset since it is centered in layer.
      final assetHeight = assetWidth * asset.height / asset.width;

      canvas
        ..save()
        ..translate(insideFrameX + assetDx, insideFrameY + assetDy)
        ..translate(assetWidth / 2, assetHeight / 2)
        ..rotate(layer.angle)
        ..translate(-assetWidth / 2, -assetHeight / 2)
        ..drawImage(
          asset.imageElement,
          0,
          0,
          assetWidth.toInt(),
          assetHeight.toInt(),
        )
        ..restore();
    }

    /// To data url will convert canvas contents to 64bit encoded PNG.
    final dataUrl = await canvas.toDataUrl();
    return base64.decode(dataUrl.split(',')[1]);
  }
}

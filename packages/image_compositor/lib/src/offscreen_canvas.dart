// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// {@template offscreen_canvas}
/// Polyfill for html.OffscreenCanvas that is not supported on some browsers.
/// {@endtemplate}
class OffScreenCanvas {
  /// {@macro offscreen_canvas}
  OffScreenCanvas(this.width, this.height) {
    if (OffScreenCanvas.supported) {
      _offScreenCanvas = html.OffscreenCanvas(width, height);
    } else {
      _canvasElement = html.CanvasElement(
        width: width,
        height: height,
      );
      _canvasElement!.className = 'gl-canvas';
      final cssWidth = width / html.window.devicePixelRatio;
      final cssHeight = height / html.window.devicePixelRatio;
      _canvasElement!.style
        ..position = 'absolute'
        ..width = '${cssWidth}px'
        ..height = '${cssHeight}px';
    }

    /// Initialize context.
    getContext2d();
  }

  html.OffscreenCanvas? _offScreenCanvas;
  html.CanvasElement? _canvasElement;

  /// The desired width of the canvas.
  final int width;

  /// The desired height of the canvas.
  final int height;
  Object? _context;
  static bool? _supported;

  /// Clears internal state which includes references various canvas elements.
  void dispose() {
    _offScreenCanvas = null;
    _canvasElement = null;
  }

  /// Generates a data url from the offscreen canvas.
  Future<String> toDataUrl() {
    final completer = Completer<String>();
    if (_offScreenCanvas != null) {
      _offScreenCanvas!.convertToBlob().then((html.Blob value) {
        final fileReader = html.FileReader();
        fileReader.onLoad.listen((event) {
          completer.complete(
            js_util.getProperty(
              js_util.getProperty(event, 'target')!,
              'result',
            ),
          );
        });
        fileReader.readAsDataUrl(value);
      });
      return completer.future;
    } else {
      return Future.value(_canvasElement!.toDataUrl());
    }
  }

  /// Returns CanvasRenderContext2D or OffscreenCanvasRenderingContext2D to
  /// paint into.
  Object? getContext2d() => _context ??= _offScreenCanvas != null
      ? _offScreenCanvas!.getContext('2d')
      : _canvasElement!.getContext('2d');

  /// Proxy to `canvas.getContext('2d').save()`.
  void save() {
    js_util.callMethod<void>(_context!, 'save', const <dynamic>[]);
  }

  /// Proxy to `canvas.getContext('2d').restore()`.
  void restore() {
    js_util.callMethod<void>(_context!, 'restore', const <dynamic>[]);
  }

  /// Proxy to `canvas.getContext('2d').translate()`.
  void translate(double x, double y) {
    js_util.callMethod<void>(_context!, 'translate', <dynamic>[x, y]);
  }

  /// Proxy to `canvas.getContext('2d').rotate()`.
  void rotate(double angle) {
    js_util.callMethod<void>(_context!, 'rotate', <dynamic>[angle]);
  }

  /// Proxy to `canvas.getContext('2d').drawImage()`.
  void drawImage(Object image, int x, int y, int width, int height) {
    js_util.callMethod<void>(
      _context!,
      'drawImage',
      <dynamic>[image, x, y, width, height],
    );
  }

  /// Creates a rectangular path whose starting point is at (x, y) and
  /// whose size is specified by width and height and clips the path.
  void clipRect(int x, int y, int width, int height) {
    js_util.callMethod<void>(_context!, 'beginPath', const <dynamic>[]);
    js_util.callMethod<void>(_context!, 'rect', <dynamic>[x, y, width, height]);
    js_util.callMethod<void>(_context!, 'clip', const <dynamic>[]);
  }

  /// Feature detection for transferToImageBitmap on OffscreenCanvas.
  bool get transferToImageBitmapSupported =>
      js_util.hasProperty(_offScreenCanvas!, 'transferToImageBitmap');

  /// Creates an ImageBitmap object from the most recently rendered image
  /// of the OffscreenCanvas.
  ///
  /// !Warning API still in experimental status, feature detect before using.
  Object? transferToImageBitmap() {
    return js_util
        .callMethod(_offScreenCanvas!, 'transferToImageBitmap', <dynamic>[]);
  }

  /// Draws canvas contents to a rendering context.
  void transferImage(Object targetContext) {
    // Actual size of canvas may be larger than viewport size. Use
    // source/destination to draw part of the image data.
    js_util.callMethod<void>(targetContext, 'drawImage', <dynamic>[
      _offScreenCanvas ?? _canvasElement!,
      0,
      0,
      width,
      height,
      0,
      0,
      width,
      height
    ]);
  }

  /// Feature detects OffscreenCanvas.
  static bool get supported =>
      _supported ??= js_util.hasProperty(html.window, 'OffscreenCanvas');
}

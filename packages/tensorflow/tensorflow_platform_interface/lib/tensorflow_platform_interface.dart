// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'src/method_channel_tensorflow.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of tensorflow must implement.
///
/// Platform implementations should extend this class rather than implement it as `Tensorflow`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [TensorflowPlatform] methods.
abstract class TensorflowPlatform extends PlatformInterface {
  /// Constructs a ConnectivityPlatform.
  TensorflowPlatform() : super(token: _token);

  static final Object _token = Object();

  static TensorflowPlatform _instance = MethodChannelTensorflow();

  /// The default instance of [TensorflowPlatform] to use.
  ///
  /// Defaults to [MethodChannelTensorflow].
  static TensorflowPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [TensorflowPlatform] when they register themselves.
  static set instance(TensorflowPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

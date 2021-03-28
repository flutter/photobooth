import 'package:camera_platform_interface/camera_platform_interface.dart';

/// An implementation of [CameraPlatform] that uses a `MethodChannel`
/// to communicate with the native code.
///
/// The `camera` plugin code itself never talks to the native code directly.
/// It delegates all calls to an instance of a class
/// that extends the [CameraPlatform].
///
/// The architecture above allows for platforms that communicate differently
/// with the native side (like web) to have a common interface to extend.
///
/// This is the instance that runs when the native side talks
/// to your Flutter app through MethodChannels (Android and iOS platforms).
class MethodChannelCamera extends CameraPlatform {}

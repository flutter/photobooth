import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'desktop_draggable_resizable_image.dart';
import 'mobile_draggable_resizable_image.dart';
export 'desktop_draggable_resizable_image.dart';
export 'mobile_draggable_resizable_image.dart';

/// {@template draggable_resizable_asset}
/// A widget which allows a user to drag and resize the provided [asset].
/// {@endtemplate}
class DraggableResizableAsset extends StatelessWidget {
  /// {@macro draggable_resizable_asset}
  const DraggableResizableAsset({
    Key? key,
    required this.asset,
  }) : super(key: key);

  /// The asset which will be rendered and will be draggable and resizable.
  final Asset asset;
  @override
  Widget build(BuildContext context) {
    if (PlatformHelper().isMobile)
      return MobileDraggableResizableImage(
        image: asset.bytes,
        height: asset.image.height.toDouble(),
      );
    return DesktopDraggableResizableImage(
      image: asset.bytes,
      height: asset.image.height.toDouble(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photobooth_ui/src/platform_helper/platform_helper.dart';
import 'desktop_draggable_resizable_image.dart';
import 'mobile_draggable_resizable_image.dart';
export 'desktop_draggable_resizable_image.dart';
export 'mobile_draggable_resizable_image.dart';

/// {@template draggable_resizable_asset}
/// A widget which allows a user to drag and resize the provided [asset].
/// {@endtemplate}
class DraggableResizableAsset extends StatefulWidget {
  /// {@macro draggable_resizable_asset}
  const DraggableResizableAsset({
    Key? key,
    required this.asset,
  }) : super(key: key);

  /// The asset which will be rendered and will be draggable and resizable.
  final Asset asset;

  @override
  _DraggableResizableAssetState createState() =>
      _DraggableResizableAssetState();
}

class _DraggableResizableAssetState extends State<DraggableResizableAsset> {
  @override
  Widget build(BuildContext context) {
    if (PlatformHelper.isMobile)
      return MobileDraggableResizableImage(
        image: widget.asset.bytes,
        height: widget.asset.image.height.toDouble(),
      );
    return DesktopDraggableResizableImage(
      image: widget.asset.bytes,
      height: widget.asset.image.height.toDouble(),
    );
  }
}

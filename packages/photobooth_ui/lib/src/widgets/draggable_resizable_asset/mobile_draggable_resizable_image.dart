import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template mobile_draggable_resizable_image}
/// A widget which allows a user to drag and resize the provided [image]
/// on mobile.
/// {@endtemplate}
class MobileDraggableResizableImage extends StatefulWidget {
  /// {@macro mobile_draggable_resizable_image}
  MobileDraggableResizableImage({
    Key? key,
    required this.image,
    required this.height,
    this.onUpdate,
  }) : super(key: key);

  @override
  _MobileDraggableResizableImageState createState() =>
      _MobileDraggableResizableImageState();

  /// Image that will be draggable and resizable
  final Uint8List image;

  /// Height image
  final double height;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;
}

class _MobileDraggableResizableImageState
    extends State<MobileDraggableResizableImage> {
  late double height;
  late double width;
  late double minHeight;
  late double maxHeight;
  late BoxConstraints constraints;
  late double initX;
  late double initY;
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  double? top;
  double? left;
  Size? initialSize;

  @override
  void initState() {
    super.initState();
    maxHeight = widget.height.toDouble();
    minHeight = maxHeight * 0.05;
    height = maxHeight * 0.25;
    width = height;
    constraints = const BoxConstraints.expand(width: 1, height: 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        initialSize ??= Size(constraints.maxWidth, constraints.maxHeight);
        left = left ??= constraints.maxWidth / 2 - (width / 2);
        top = top ??= constraints.maxHeight / 2 - (height / 2);

        final widthFactor = constraints.maxWidth / initialSize!.width;
        final heightFactor = constraints.maxHeight / initialSize!.height;

        final normalizedWidth = width * widthFactor;
        final normalizedHeight = height * heightFactor;

        final normalizedLeft = left! * widthFactor;
        final normalizedTop = top! * heightFactor;

        void onUpdate() {
          widget.onUpdate?.call(
            DragUpdate(
              position: Offset(normalizedLeft, normalizedTop),
              size: Size(normalizedWidth, normalizedHeight),
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          );
        }

        if (this.constraints != constraints) {
          this.constraints = constraints;
          onUpdate();
        }

        return Stack(
          children: [
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform.scale(
                scale: _scaleFactor,
                alignment: Alignment.center,
                child: GestureDetector(
                  onScaleStart: (details) {
                    if (details.pointerCount == 1) {
                      initX = details.focalPoint.dx;
                      initY = details.focalPoint.dy;
                    } else {
                      _baseScaleFactor = _scaleFactor;
                    }
                  },
                  onScaleUpdate: (details) {
                    if (details.pointerCount == 1) {
                      final dx = details.focalPoint.dx - initX;
                      final dy = details.focalPoint.dy - initY;
                      initX = details.focalPoint.dx;
                      initY = details.focalPoint.dy;
                      setState(() {
                        top = top! + (dy / heightFactor);
                        left = left! + (dx / widthFactor);
                      });

                      onUpdate();
                    } else {
                      setState(() {
                        _scaleFactor = _baseScaleFactor * details.scale;
                      });

                      onUpdate();
                    }
                  },
                  child: Container(
                    height: normalizedHeight,
                    width: normalizedWidth,
                    child: Image.memory(
                      widget.image,
                      key: const Key('mobileDraggableResizableImage_image'),
                      height: normalizedHeight,
                      width: normalizedWidth,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

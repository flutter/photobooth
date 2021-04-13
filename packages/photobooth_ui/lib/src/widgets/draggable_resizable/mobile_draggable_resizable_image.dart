import 'dart:typed_data';

import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  _MobileDraggableResizableImageState createState() =>
      _MobileDraggableResizableImageState();

  /// Image that will be draggable and resizable
  final Uint8List image;

  /// Height image
  final double height;
}

class _MobileDraggableResizableImageState
    extends State<MobileDraggableResizableImage> {
  late double _width;
  late double _height;

  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;

  late double initX;
  late double initY;

  late double top;
  late double left;

  @override
  void initState() {
    super.initState();
    _height = widget.height * 0.1;
    _width = _height;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    left = MediaQuery.of(context).size.width / 2 - (_width / 2);
    top = MediaQuery.of(context).size.height / 2 - (_height / 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          child: Transform.scale(
            scale: _scaleFactor,
            alignment: Alignment.center,
            child: GestureDetector(
              onScaleStart: (details) {
                print('onScaleStart');
                if (details.pointerCount == 1) {
                  initX = details.focalPoint.dx;
                  initY = details.focalPoint.dy;
                } else {
                  _baseScaleFactor = _scaleFactor;
                }
              },
              onScaleUpdate: (details) {
                print('onScaleUpdate ${details.pointerCount}');
                if (details.pointerCount == 1) {
                  final dx = details.focalPoint.dx - initX;
                  final dy = details.focalPoint.dy - initY;
                  initX = details.focalPoint.dx;
                  initY = details.focalPoint.dy;
                  setState(() {
                    top = top + dy;
                    left = left + dx;
                  });
                } else {
                  setState(() {
                    _scaleFactor = _baseScaleFactor * details.scale;
                  });
                }
              },
              child: Container(
                height: _height,
                width: _width,
                child: Image.memory(
                  widget.image,
                  key: const Key('mobileDraggableResizableImage_image'),
                  height: _height,
                  width: _width,
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

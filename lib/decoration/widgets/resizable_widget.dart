import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class ResizebleSticker extends StatefulWidget {
  ResizebleSticker({required this.sticker});

  final Asset sticker;
  @override
  _ResizebleStickerState createState() => _ResizebleStickerState();
}

const ballDiameter = 30.0;

class _ResizebleStickerState extends State<ResizebleSticker> {
  late double height;
  late double width;
  late double minHeight;
  late double maxHeight;
  late double minWidth;
  late double maxWidth;

  double top = 0;
  double left = 0;

  @override
  void initState() {
    super.initState();
    maxHeight = widget.sticker.image.height.toDouble();
    minHeight = maxHeight * 0.5;
    height = maxHeight * 0.75;

    maxWidth = widget.sticker.image.width.toDouble();
    minWidth = maxWidth * 0.5;
    width = maxWidth * 0.75;
  }

  double _getNewHeight(double value) {
    if (value >= maxHeight) return maxHeight;
    if (value <= minHeight) return minHeight;
    return value;
  }

  double _getNewWidth(double value) {
    if (value >= maxWidth) return maxWidth;
    if (value <= minWidth) return minWidth;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: DraggableContainer(
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
              });
            },
            child: Container(
              height: height,
              width: width,
              child: Image.memory(
                Uint8List.fromList(widget.sticker.data),
                height: height,
                width: width,
              ),
            ),
          ),
        ),
        // top left
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var tempNewHeight = height - 2 * mid;
              var tempNewWidth = width - 2 * mid;

              setState(() {
                height = _getNewHeight(tempNewHeight);
                width = _getNewWidth(tempNewWidth);
                top = top + mid;
                left = left + mid;
              });
            },
          ),
        ),

        // top right
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = _getNewHeight(newHeight);
                width = _getNewWidth(newWidth);
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),

        // bottom right
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = _getNewHeight(newHeight);
                width = _getNewWidth(newWidth);
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),

        // bottom left
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = _getNewHeight(newHeight);
                width = _getNewWidth(newWidth);
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
      ],
    );
  }
}

class DraggableContainer extends StatefulWidget {
  DraggableContainer({
    Key? key,
    required this.onDrag,
    required this.child,
  }) : super(key: key);
  final Function onDrag;
  final Widget child;

  @override
  _DraggableContainerState createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: widget.child,
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key? key, required this.onDrag}) : super(key: key);

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

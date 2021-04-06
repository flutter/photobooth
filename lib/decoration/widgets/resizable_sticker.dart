import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:io_photobooth/assets/assets.dart';

class ResizebleSticker extends StatefulWidget {
  ResizebleSticker({required this.sticker});

  final Asset sticker;
  @override
  _ResizebleStickerState createState() => _ResizebleStickerState();
}

const ballDiameter = 15.0;

class _ResizebleStickerState extends State<ResizebleSticker> {
  late double height;
  late double width;
  late double minHeight;
  late double maxHeight;
  late double minWidth;
  late double maxWidth;

  double top = 0;
  double left = 0;

  bool get maxHeightAvailable => height >= maxHeight;
  bool get maxWidthAvailable => width >= maxWidth;

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
        //Image
        Positioned(
          top: top,
          left: left,
          child: _DraggablePoint(
            key: const Key('resizableSticker_image_draggablePoint'),
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
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
        // Top Left Corner
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: _ResizePoint(
            key: const Key('resizableSticker_topLeft_draggablePoint'),
            onDrag: (dx, dy) {
              final mid = (dx + dy) / 2;
              final tempNewHeight = height - 2 * mid;
              final tempNewWidth = width - 2 * mid;
              if (tempNewHeight >= maxHeight || tempNewHeight <= minHeight)
                return;

              setState(() {
                height = _getNewHeight(tempNewHeight);
                width = _getNewWidth(tempNewWidth);
                top = top + mid;
                left = left + mid;
              });
            },
          ),
        ),

        // Top Right corner
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: _ResizePoint(
            key: const Key('resizableSticker_topRight_draggablePoint'),
            onDrag: (dx, dy) {
              final mid = (dx + (dy * -1)) / 2;
              final tempNewHeight = height + 2 * mid;
              final tempNewWidth = width + 2 * mid;

              if (tempNewHeight >= maxHeight || tempNewHeight <= minHeight)
                return;

              setState(() {
                height = _getNewHeight(tempNewHeight);
                width = _getNewWidth(tempNewWidth);
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),

        // Bottom right corner
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: _ResizePoint(
            key: const Key('resizableSticker_bottomRight_draggablePoint'),
            onDrag: (dx, dy) {
              final mid = (dx + dy) / 2;
              final tempNewHeight = height + 2 * mid;
              final tempNewWidth = width + 2 * mid;

              if (tempNewHeight >= maxHeight || tempNewHeight <= minHeight)
                return;

              setState(() {
                height = _getNewHeight(tempNewHeight);
                width = _getNewWidth(tempNewWidth);
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),

        // Bottom left corner
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: _ResizePoint(
            key: const Key('resizableSticker_bottomLeft_draggablePoint'),
            onDrag: (dx, dy) {
              final mid = ((dx * -1) + dy) / 2;
              final tempNewHeight = height + 2 * mid;
              final tempNewWidth = width + 2 * mid;

              if (tempNewHeight >= maxHeight || tempNewHeight <= minHeight)
                return;

              setState(() {
                height = _getNewHeight(tempNewHeight);
                width = _getNewWidth(tempNewWidth);
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

class _ResizePoint extends StatelessWidget {
  const _ResizePoint({Key? key, required this.onDrag}) : super(key: key);

  final Function onDrag;

  @override
  Widget build(BuildContext context) {
    return _DraggablePoint(
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
      onDrag: onDrag,
    );
  }
}

class _DraggablePoint extends StatefulWidget {
  const _DraggablePoint({Key? key, required this.child, required this.onDrag})
      : super(key: key);

  final Widget child;
  final Function onDrag;

  @override
  __DraggablePointState createState() => __DraggablePointState();
}

class __DraggablePointState extends State<_DraggablePoint> {
  late double initX;
  late double initY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
      },
      onPanUpdate: (details) {
        final dx = details.globalPosition.dx - initX;
        final dy = details.globalPosition.dy - initY;
        initX = details.globalPosition.dx;
        initY = details.globalPosition.dy;
        widget.onDrag(dx, dy);
      },
      child: widget.child,
    );
  }
}

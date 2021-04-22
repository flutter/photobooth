import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _cornerDiameter = 15.0;
const _floatingActionDiameter = 45.0;
const _floatingActionPadding = 100.0;

/// {@template desktop_draggable_resizable_image}
/// A widget which allows a user to drag and resize the provided [image].
/// {@endtemplate}
class DesktopDraggableResizableImage extends StatefulWidget {
  /// {@macro draggable_resizable_asset}
  DesktopDraggableResizableImage({
    Key? key,
    required this.image,
    required this.height,
    this.onUpdate,
    this.onDelete,
    this.canTransform = false,
  }) : super(key: key);

  /// Image that will be draggable and resizable
  final Uint8List image;

  /// Height image
  final double height;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;

  /// Delete callback
  final VoidCallback? onDelete;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  @override
  _DesktopDraggableResizableImageState createState() =>
      _DesktopDraggableResizableImageState();
}

class _DesktopDraggableResizableImageState
    extends State<DesktopDraggableResizableImage> {
  late Size size;
  late double minHeight;
  late double maxHeight;
  late BoxConstraints constraints;
  late double angle;

  Offset position = Offset.zero;
  Size? initialSize;

  @override
  void initState() {
    super.initState();
    maxHeight = widget.height.toDouble();
    minHeight = maxHeight * 0.05;
    size = Size(maxHeight * 0.25, maxHeight * 0.25);
    constraints = const BoxConstraints.expand(width: 1, height: 1);
    angle = 0;
  }

  double clampHeight(double value) {
    if (value >= maxHeight) return maxHeight;
    if (value <= minHeight) return minHeight;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        initialSize ??= Size(constraints.maxWidth, constraints.maxHeight);
        position = position == Offset.zero
            ? Offset(
                constraints.maxWidth / 2 - (size.width / 2),
                constraints.maxHeight / 2 - (size.height / 2),
              )
            : position;

        final widthFactor = constraints.maxWidth / initialSize!.width;
        final heightFactor = constraints.maxHeight / initialSize!.height;

        final normalizedWidth = size.width * widthFactor;
        final normalizedHeight = size.height * heightFactor;

        final normalizedLeft = position.dx * widthFactor;
        final normalizedTop = position.dy * heightFactor;

        void onUpdate() {
          final normalizedPosition = Offset(
            normalizedLeft +
                (_floatingActionPadding / 2) +
                (_cornerDiameter / 2),
            normalizedTop +
                (_floatingActionPadding / 2) +
                (_cornerDiameter / 2),
          );
          widget.onUpdate?.call(
            DragUpdate(
              position: normalizedPosition,
              size: Size(normalizedWidth, normalizedHeight),
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
              angle: angle,
            ),
          );
        }

        void onDragTopLeft(double dx, double dy) {
          final mid = (dx + dy) / 2;
          final newHeight = (size.height - 2 * mid).abs();
          final newWidth = (size.width - 2 * mid).abs();

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(
            newWidth,
            clampHeight(newHeight),
          );
          final updatedPosition = Offset(
            position.dx + mid,
            position.dy + mid,
          );
          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragTopRight(double dx, double dy) {
          final mid = (dx + (dy * -1)) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(
            newWidth,
            clampHeight(newHeight),
          );
          final updatedPosition = Offset(
            position.dx - mid,
            position.dy - mid,
          );

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomLeft(double dx, double dy) {
          final mid = ((dx * -1) + dy) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(
            newWidth,
            clampHeight(newHeight),
          );
          final updatedPosition = Offset(
            position.dx - mid,
            position.dy - mid,
          );

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomRight(double dx, double dy) {
          final mid = (dx + dy) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(
            newWidth,
            clampHeight(newHeight),
          );
          final updatedPosition = Offset(
            position.dx - mid,
            position.dy - mid,
          );

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        final topLeftCorner = _ResizePoint(
          key: const Key('draggableResizableAsset_topLeft_resizePoint'),
          onDrag: onDragTopLeft,
        );

        final topRightCorner = _ResizePoint(
          key: const Key('draggableResizableAsset_topRight_resizePoint'),
          onDrag: onDragTopRight,
        );

        final bottomLeftCorner = _ResizePoint(
          key: const Key('draggableResizableAsset_bottomLeft_resizePoint'),
          onDrag: onDragBottomLeft,
        );

        final bottomRightCorner = _ResizePoint(
          key: const Key('draggableResizableAsset_bottomRight_resizePoint'),
          onDrag: onDragBottomRight,
        );

        if (this.constraints != constraints) {
          this.constraints = constraints;
          onUpdate();
        }

        return Stack(
          children: <Widget>[
            // Image
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform.rotate(
                angle: angle,
                child: _DraggablePoint(
                  key: const Key(
                    'draggableResizableAsset_image_draggablePoint',
                  ),
                  onTap: onUpdate,
                  onDrag: (dx, dy) {
                    setState(() {
                      position = Offset(
                        position.dx + (dx / widthFactor),
                        position.dy + (dy / heightFactor),
                      );
                    });
                    onUpdate();
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: normalizedHeight +
                            _cornerDiameter +
                            _floatingActionPadding,
                        width: normalizedWidth +
                            _cornerDiameter +
                            _floatingActionPadding,
                        child: Container(
                          height: normalizedHeight,
                          width: normalizedWidth,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: widget.canTransform
                                  ? PhotoboothColors.blue
                                  : PhotoboothColors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Image.memory(
                            widget.image,
                            height: normalizedHeight,
                            width: normalizedWidth,
                            gaplessPlayback: true,
                          ),
                        ),
                      ),

                      if (widget.canTransform) ...[
                        Positioned(
                          top: _floatingActionPadding / 2,
                          left: _floatingActionPadding / 2,
                          child: topLeftCorner,
                        ),
                        Positioned(
                          top: _floatingActionPadding / 2,
                          left: normalizedWidth + _floatingActionPadding / 2,
                          child: topRightCorner,
                        ),
                        Positioned(
                          top: normalizedHeight + _floatingActionPadding / 2,
                          left: _floatingActionPadding / 2,
                          child: bottomLeftCorner,
                        ),
                        Positioned(
                          top: normalizedHeight + _floatingActionPadding / 2,
                          left: normalizedWidth + _floatingActionPadding / 2,
                          child: bottomRightCorner,
                        ),
                      ],

                      // Delete button
                      if (widget.onDelete != null && widget.canTransform)
                        Positioned(
                          top: (normalizedHeight / 2) -
                              (_floatingActionDiameter / 2) +
                              (_cornerDiameter / 2) +
                              (_floatingActionPadding / 2),
                          left: normalizedWidth +
                              (_floatingActionDiameter / 2) +
                              (_floatingActionPadding / 2) -
                              (_cornerDiameter / 2),
                          child: Material(
                            color: PhotoboothColors.transparent,
                            clipBehavior: Clip.hardEdge,
                            shape: const CircleBorder(),
                            child: InkWell(
                              onTap: widget.onDelete,
                              child: Image.asset(
                                'assets/images/delete_circle_icon.png',
                                key: const Key(
                                  'draggableResizableAsset_delete_image',
                                ),
                                package: 'photobooth_ui',
                                width: _floatingActionDiameter,
                                height: _floatingActionDiameter,
                              ),
                            ),
                          ),
                        ),

                      // Rotate button
                      if (widget.canTransform)
                        Positioned(
                          top: 0,
                          left: (normalizedWidth / 2) -
                              (_floatingActionDiameter / 2) +
                              (_cornerDiameter / 2) +
                              (_floatingActionPadding / 2),
                          child: GestureDetector(
                            onPanUpdate: (d) {
                              setState(() => angle = d.localPosition.direction);
                            },
                            child: Material(
                              color: PhotoboothColors.transparent,
                              clipBehavior: Clip.hardEdge,
                              shape: const CircleBorder(),
                              child: InkWell(
                                child: Image.asset(
                                  'assets/images/rotate_circle_icon.png',
                                  key: const Key(
                                      'draggableResizableAsset_rotate_image'),
                                  package: 'photobooth_ui',
                                  width: _floatingActionDiameter,
                                  height: _floatingActionDiameter,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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

class _ResizePoint extends StatelessWidget {
  const _ResizePoint({Key? key, required this.onDrag}) : super(key: key);

  final void Function(double, double) onDrag;

  @override
  Widget build(BuildContext context) {
    return _DraggablePoint(
      mode: _PositionMode.local,
      onDrag: onDrag,
      child: Container(
        width: _cornerDiameter,
        height: _cornerDiameter,
        decoration: BoxDecoration(
          border: Border.all(color: PhotoboothColors.blue, width: 2),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: PhotoboothColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

enum _PositionMode { local, global }

class _DraggablePoint extends StatefulWidget {
  const _DraggablePoint({
    Key? key,
    required this.child,
    required this.onDrag,
    this.onTap,
    this.mode = _PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final _PositionMode mode;
  final void Function(double, double) onDrag;
  final VoidCallback? onTap;

  @override
  _DraggablePointState createState() => _DraggablePointState();
}

class _DraggablePointState extends State<_DraggablePoint> {
  late double initX;
  late double initY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: (details) {
        switch (widget.mode) {
          case _PositionMode.global:
            initX = details.globalPosition.dx;
            initY = details.globalPosition.dy;
            break;
          case _PositionMode.local:
            initX = details.localPosition.dx;
            initY = details.localPosition.dy;
            break;
        }
      },
      onPanUpdate: (details) {
        switch (widget.mode) {
          case _PositionMode.global:
            final dx = details.globalPosition.dx - initX;
            final dy = details.globalPosition.dy - initY;
            initX = details.globalPosition.dx;
            initY = details.globalPosition.dy;
            widget.onDrag(dx, dy);
            break;
          case _PositionMode.local:
            final dx = details.localPosition.dx - initX;
            final dy = details.localPosition.dy - initY;
            initX = details.localPosition.dx;
            initY = details.localPosition.dy;
            widget.onDrag(dx, dy);
            break;
        }
      },
      child: widget.child,
    );
  }
}

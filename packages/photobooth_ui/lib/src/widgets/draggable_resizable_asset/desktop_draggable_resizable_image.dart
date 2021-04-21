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
  late double height;
  late double width;
  late double minHeight;
  late double maxHeight;
  late BoxConstraints constraints;
  late double angle;

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
    angle = 0;
  }

  double _getNewHeight(double value) {
    if (value >= maxHeight) return maxHeight;
    if (value <= minHeight) return minHeight;
    return value;
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
              position: Offset(
                normalizedLeft +
                    (_floatingActionPadding / 2) +
                    (_cornerDiameter / 2),
                normalizedTop +
                    (_floatingActionPadding / 2) +
                    (_cornerDiameter / 2),
              ),
              size: Size(normalizedWidth, normalizedHeight),
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
              angle: angle,
            ),
          );
        }

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
                      top = top! + (dy / heightFactor);
                      left = left! + (dx / widthFactor);
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

                      // Top Left Corner
                      if (widget.canTransform)
                        Positioned(
                          top: _floatingActionPadding / 2,
                          left: _floatingActionPadding / 2,
                          child: Center(
                            child: _ResizePoint(
                              key: const Key(
                                'draggableResizableAsset_topLeft_resizePoint',
                              ),
                              onDrag: (dx, dy) {
                                final mid = (dx + dy) / 2;
                                final tempNewHeight = (height - 2 * mid).abs();
                                final tempNewWidth = (width - 2 * mid).abs();

                                if (tempNewHeight >= maxHeight ||
                                    tempNewHeight <= minHeight) {
                                  return;
                                }

                                setState(() {
                                  height = _getNewHeight(tempNewHeight);
                                  width = tempNewWidth;
                                  top = top! + mid;
                                  left = left! + mid;
                                });

                                onUpdate();
                              },
                            ),
                          ),
                        ),

                      // Top Right corner
                      if (widget.canTransform)
                        Positioned(
                          top: _floatingActionPadding / 2,
                          left: normalizedWidth + _floatingActionPadding / 2,
                          child: _ResizePoint(
                            key: const Key(
                              'draggableResizableAsset_topRight_resizePoint',
                            ),
                            onDrag: (dx, dy) {
                              final mid = (dx + (dy * -1)) / 2;
                              final tempNewHeight = height + 2 * mid;
                              final tempNewWidth = width + 2 * mid;

                              if (tempNewHeight >= maxHeight ||
                                  tempNewHeight <= minHeight) {
                                return;
                              }

                              setState(() {
                                height = _getNewHeight(tempNewHeight);
                                width = tempNewWidth;
                                top = top! - mid;
                                left = left! - mid;
                              });

                              onUpdate();
                            },
                          ),
                        ),

                      // Bottom right corner
                      if (widget.canTransform)
                        Positioned(
                          top: normalizedHeight + _floatingActionPadding / 2,
                          left: normalizedWidth + _floatingActionPadding / 2,
                          child: _ResizePoint(
                            key: const Key(
                              'draggableResizableAsset_bottomRight_resizePoint',
                            ),
                            onDrag: (dx, dy) {
                              final mid = (dx + dy) / 2;
                              final tempNewHeight = height + 2 * mid;
                              final tempNewWidth = width + 2 * mid;

                              if (tempNewHeight >= maxHeight ||
                                  tempNewHeight <= minHeight) {
                                return;
                              }

                              setState(() {
                                height = _getNewHeight(tempNewHeight);
                                width = tempNewWidth;
                                top = top! - mid;
                                left = left! - mid;
                              });

                              onUpdate();
                            },
                          ),
                        ),

                      // Bottom left corner
                      if (widget.canTransform)
                        Positioned(
                          top: normalizedHeight + _floatingActionPadding / 2,
                          left: 0 + _floatingActionPadding / 2,
                          child: _ResizePoint(
                            key: const Key(
                              'draggableResizableAsset_bottomLeft_resizePoint',
                            ),
                            onDrag: (dx, dy) {
                              final mid = ((dx * -1) + dy) / 2;
                              final tempNewHeight = height + 2 * mid;
                              final tempNewWidth = width + 2 * mid;

                              if (tempNewHeight >= maxHeight ||
                                  tempNewHeight <= minHeight) {
                                return;
                              }

                              setState(() {
                                height = _getNewHeight(tempNewHeight);
                                width = tempNewWidth;
                                top = top! - mid;
                                left = left! - mid;
                              });

                              onUpdate();
                            },
                          ),
                        ),

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
                                    'draggableResizableAsset_delete_image'),
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

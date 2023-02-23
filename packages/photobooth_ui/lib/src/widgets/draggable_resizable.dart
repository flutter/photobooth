import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.angle,
    required this.position,
    required this.size,
    required this.constraints,
  });

  /// The angle of the draggable asset.
  final double angle;

  /// The position of the draggable asset.
  final Offset position;

  /// The size of the draggable asset.
  final Size size;

  /// The constraints of the parent view.
  final Size constraints;
}

const _cornerDiameter = 15.0;
const _floatingActionDiameter = 45.0;
const _floatingActionPadding = 100.0;

/// {@template draggable_resizable}
/// A widget which allows a user to drag and resize the provided [child].
/// {@endtemplate}
class DraggableResizable extends StatefulWidget {
  /// {@macro draggable_resizable}
  DraggableResizable({
    required this.child,
    required this.size,
    BoxConstraints? constraints,
    this.onUpdate,
    this.onDelete,
    this.canTransform = false,
    PlatformHelper? platformHelper,
    super.key,
  })  : constraints = constraints ?? BoxConstraints.loose(Size.infinite),
        platformHelper = platformHelper ?? PlatformHelper();

  /// The child which will be draggable/resizable.
  final Widget child;

  /// Drag/Resize value setter.
  final ValueSetter<DragUpdate>? onUpdate;

  /// Delete callback
  final VoidCallback? onDelete;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  /// The child's original size.
  final Size size;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  final BoxConstraints constraints;

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  State<DraggableResizable> createState() => _DraggableResizableState();
}

class _DraggableResizableState extends State<DraggableResizable> {
  late Size size;
  late BoxConstraints constraints;
  late double angle;
  late double angleDelta;
  late double baseAngle;

  bool get isTouchInputSupported => widget.platformHelper.isMobile;

  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    constraints = const BoxConstraints.expand(width: 1, height: 1);
    angle = 0;
    baseAngle = 0;
    angleDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.size.width / widget.size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        position = position == Offset.zero
            ? Offset(
                constraints.maxWidth / 2 - (size.width / 2),
                constraints.maxHeight / 2 - (size.height / 2),
              )
            : position;

        final normalizedWidth = size.width;
        final normalizedHeight = normalizedWidth / aspectRatio;
        final newSize = Size(normalizedWidth, normalizedHeight);

        if (widget.constraints.isSatisfiedBy(newSize)) size = newSize;

        final normalizedLeft = position.dx;
        final normalizedTop = position.dy;

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
              size: size,
              constraints: Size(constraints.maxWidth, constraints.maxHeight),
              angle: angle,
            ),
          );
        }

        void onDragTopLeft(Offset details) {
          final mid = (details.dx + details.dy) / 2;
          final newHeight = math.max<double>(size.height - (2 * mid), 0);
          final newWidth = math.max<double>(size.width - (2 * mid), 0);
          final updatedSize = Size(newWidth, newHeight);

          if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx + mid, position.dy + mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragTopRight(Offset details) {
          final mid = (details.dx + (details.dy * -1)) / 2;
          final newHeight = math.max<double>(size.height + (2 * mid), 0);
          final newWidth = math.max<double>(size.width + (2 * mid), 0);
          final updatedSize = Size(newWidth, newHeight);

          if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomLeft(Offset details) {
          final mid = ((details.dx * -1) + details.dy) / 2;
          final newHeight = math.max<double>(size.height + (2 * mid), 0);
          final newWidth = math.max<double>(size.width + (2 * mid), 0);
          final updatedSize = Size(newWidth, newHeight);

          if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomRight(Offset details) {
          final mid = (details.dx + details.dy) / 2;
          final newHeight = math.max<double>(size.height + (2 * mid), 0);
          final newWidth = math.max<double>(size.width + (2 * mid), 0);
          final updatedSize = Size(newWidth, newHeight);

          if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        final decoratedChild = Container(
          key: const Key('draggableResizable_child_container'),
          alignment: Alignment.center,
          height: normalizedHeight + _cornerDiameter + _floatingActionPadding,
          width: normalizedWidth + _cornerDiameter + _floatingActionPadding,
          child: Container(
            height: normalizedHeight,
            width: normalizedWidth,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: widget.canTransform
                    ? PhotoboothColors.blue
                    : PhotoboothColors.transparent,
              ),
            ),
            child: Center(child: widget.child),
          ),
        );

        final topLeftCorner = _ResizePoint(
          key: const Key('draggableResizable_topLeft_resizePoint'),
          type: _ResizePointType.topLeft,
          onDrag: onDragTopLeft,
        );

        final topRightCorner = _ResizePoint(
          key: const Key('draggableResizable_topRight_resizePoint'),
          type: _ResizePointType.topRight,
          onDrag: onDragTopRight,
        );

        final bottomLeftCorner = _ResizePoint(
          key: const Key('draggableResizable_bottomLeft_resizePoint'),
          type: _ResizePointType.bottomLeft,
          onDrag: onDragBottomLeft,
        );

        final bottomRightCorner = _ResizePoint(
          key: const Key('draggableResizable_bottomRight_resizePoint'),
          type: _ResizePointType.bottomRight,
          onDrag: onDragBottomRight,
        );

        final deleteButton = _FloatingActionIcon(
          key: const Key('draggableResizable_delete_floatingActionIcon'),
          iconData: Icons.delete,
          onTap: widget.onDelete,
        );

        final center = Offset(
          (_floatingActionDiameter + _cornerDiameter) / 2,
          (normalizedHeight / 2) +
              (_floatingActionDiameter / 2) +
              (_cornerDiameter / 2) +
              (_floatingActionPadding / 2),
        );

        final rotateAnchor = GestureDetector(
          key: const Key('draggableResizable_rotate_gestureDetector'),
          onScaleStart: (details) {
            final offsetFromCenter = details.localFocalPoint - center;
            setState(() => angleDelta = baseAngle - offsetFromCenter.direction);
          },
          onScaleUpdate: (details) {
            final offsetFromCenter = details.localFocalPoint - center;
            setState(() => angle = offsetFromCenter.direction + angleDelta);
            onUpdate();
          },
          onScaleEnd: (_) => setState(() => baseAngle = angle),
          child: _FloatingActionIcon(
            key: const Key('draggableResizable_rotate_floatingActionIcon'),
            iconData: Icons.rotate_90_degrees_ccw,
            onTap: () {},
          ),
        );

        if (this.constraints != constraints) {
          this.constraints = constraints;
          onUpdate();
        }

        return Stack(
          children: <Widget>[
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(1.0)
                  ..rotateZ(angle),
                child: _DraggablePoint(
                  key: const Key('draggableResizable_child_draggablePoint'),
                  onTap: onUpdate,
                  onDrag: (d) {
                    setState(() {
                      position = Offset(position.dx + d.dx, position.dy + d.dy);
                    });
                    onUpdate();
                  },
                  onScale: (s) {
                    final updatedSize = Size(
                      widget.size.width * s,
                      widget.size.height * s,
                    );

                    if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

                    final midX = position.dx + (size.width / 2);
                    final midY = position.dy + (size.height / 2);
                    final updatedPosition = Offset(
                      midX - (updatedSize.width / 2),
                      midY - (updatedSize.height / 2),
                    );

                    setState(() {
                      size = updatedSize;
                      position = updatedPosition;
                    });
                    onUpdate();
                  },
                  onRotate: (a) {
                    setState(() => angle = a);
                    onUpdate();
                  },
                  child: Stack(
                    children: [
                      decoratedChild,
                      if (widget.canTransform && widget.onDelete != null)
                        Positioned(
                          top: (normalizedHeight / 2) -
                              (_floatingActionDiameter / 2) +
                              (_cornerDiameter / 2) +
                              (_floatingActionPadding / 2),
                          left: normalizedWidth +
                              (_floatingActionDiameter / 2) +
                              (_floatingActionPadding / 2) -
                              (_cornerDiameter / 2),
                          child: deleteButton,
                        ),
                      if (widget.canTransform && !isTouchInputSupported) ...[
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
                        Positioned(
                          top: 0,
                          left: (normalizedWidth / 2) -
                              (_floatingActionDiameter / 2) +
                              (_cornerDiameter / 2) +
                              (_floatingActionPadding / 2),
                          child: rotateAnchor,
                        ),
                      ],
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

enum _ResizePointType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

const _cursorLookup = <_ResizePointType, MouseCursor>{
  _ResizePointType.topLeft: SystemMouseCursors.resizeUpLeft,
  _ResizePointType.topRight: SystemMouseCursors.resizeUpRight,
  _ResizePointType.bottomLeft: SystemMouseCursors.resizeDownLeft,
  _ResizePointType.bottomRight: SystemMouseCursors.resizeDownRight,
};

class _ResizePoint extends StatelessWidget {
  const _ResizePoint({
    required this.onDrag,
    required this.type,
    super.key,
  });

  final ValueSetter<Offset> onDrag;
  final _ResizePointType type;

  MouseCursor get _cursor {
    return _cursorLookup[type]!;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _cursor,
      child: _DraggablePoint(
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
      ),
    );
  }
}

enum _PositionMode { local, global }

class _DraggablePoint extends StatefulWidget {
  const _DraggablePoint({
    required this.child,
    this.onDrag,
    this.onScale,
    this.onRotate,
    this.onTap,
    this.mode = _PositionMode.global,
    super.key,
  });

  final Widget child;
  final _PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final ValueSetter<double>? onScale;
  final ValueSetter<double>? onRotate;
  final VoidCallback? onTap;

  @override
  _DraggablePointState createState() => _DraggablePointState();
}

class _DraggablePointState extends State<_DraggablePoint> {
  late Offset initPoint;
  double baseScaleFactor = 1;
  double scaleFactor = 1;
  double baseAngle = 0;
  double angle = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onScaleStart: (details) {
        switch (widget.mode) {
          case _PositionMode.global:
            initPoint = details.focalPoint;
            break;
          case _PositionMode.local:
            initPoint = details.localFocalPoint;
            break;
        }
        if (details.pointerCount > 1) {
          baseAngle = angle;
          baseScaleFactor = scaleFactor;
          widget.onRotate?.call(baseAngle);
          widget.onScale?.call(baseScaleFactor);
        }
      },
      onScaleUpdate: (details) {
        switch (widget.mode) {
          case _PositionMode.global:
            final dx = details.focalPoint.dx - initPoint.dx;
            final dy = details.focalPoint.dy - initPoint.dy;
            initPoint = details.focalPoint;
            widget.onDrag?.call(Offset(dx, dy));
            break;
          case _PositionMode.local:
            final dx = details.localFocalPoint.dx - initPoint.dx;
            final dy = details.localFocalPoint.dy - initPoint.dy;
            initPoint = details.localFocalPoint;
            widget.onDrag?.call(Offset(dx, dy));
            break;
        }
        if (details.pointerCount > 1) {
          scaleFactor = baseScaleFactor * details.scale;
          widget.onScale?.call(scaleFactor);
          angle = baseAngle + details.rotation;
          widget.onRotate?.call(angle);
        }
      },
      child: widget.child,
    );
  }
}

class _FloatingActionIcon extends StatelessWidget {
  const _FloatingActionIcon({
    required this.iconData,
    this.onTap,
    super.key,
  });

  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PhotoboothColors.white,
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _floatingActionDiameter,
          width: _floatingActionDiameter,
          child: Center(
            child: Icon(
              iconData,
              color: PhotoboothColors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

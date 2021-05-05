import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.scale,
    required this.angle,
    required this.position,
    required this.size,
    required this.constraints,
  });

  /// The scale of the draggable asset.
  final double scale;

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
    Key? key,
    required this.child,
    required this.size,
    this.onUpdate,
    this.onDelete,
    this.canTransform = false,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

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

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  _DraggableResizableState createState() => _DraggableResizableState();
}

class _DraggableResizableState extends State<DraggableResizable> {
  late Size size;
  late double minHeight;
  late double maxHeight;
  late BoxConstraints constraints;
  late double angle;
  late double angleDelta;
  late double baseAngle;
  late double scale;

  bool get isTouchInputSupported => widget.platformHelper.isMobile;

  Offset position = Offset.zero;
  Size? initialSize;

  @override
  void initState() {
    super.initState();
    maxHeight = 1000;
    minHeight = maxHeight * 0.05;
    size = widget.size * 0.25;
    constraints = const BoxConstraints.expand(width: 1, height: 1);
    angle = 0;
    baseAngle = 0;
    angleDelta = 0;
    scale = 1;
  }

  double clampHeight(double value) {
    if (value >= maxHeight) return maxHeight;
    if (value <= minHeight) return minHeight;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.size.width / widget.size.height;
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
        final normalizedHeight = size.width / aspectRatio;

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
              scale: scale,
            ),
          );
        }

        void onDragTopLeft(Offset details) {
          final mid = (details.dx + details.dy) / 2;
          final newHeight = (size.height - 2 * mid).abs();
          final newWidth = (size.width - 2 * mid).abs();

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(newWidth, clampHeight(newHeight));
          final updatedPosition = Offset(position.dx + mid, position.dy + mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragTopRight(Offset details) {
          final mid = (details.dx + (details.dy * -1)) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(newWidth, clampHeight(newHeight));
          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomLeft(Offset details) {
          final mid = ((details.dx * -1) + details.dy) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(newWidth, clampHeight(newHeight));
          final updatedPosition = Offset(position.dx - mid, position.dy - mid);

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });

          onUpdate();
        }

        void onDragBottomRight(Offset details) {
          final mid = (details.dx + details.dy) / 2;
          final newHeight = size.height + 2 * mid;
          final newWidth = size.width + 2 * mid;

          if (newHeight >= maxHeight || newHeight <= minHeight) return;

          final updatedSize = Size(newWidth, clampHeight(newHeight));
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
          onDrag: onDragTopLeft,
        );

        final topRightCorner = _ResizePoint(
          key: const Key('draggableResizable_topRight_resizePoint'),
          onDrag: onDragTopRight,
        );

        final bottomLeftCorner = _ResizePoint(
          key: const Key('draggableResizable_bottomLeft_resizePoint'),
          onDrag: onDragBottomLeft,
        );

        final bottomRightCorner = _ResizePoint(
          key: const Key('draggableResizable_bottomRight_resizePoint'),
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
                  ..scale(scale)
                  ..rotateZ(angle),
                child: _DraggablePoint(
                  key: const Key('draggableResizable_child_draggablePoint'),
                  onTap: onUpdate,
                  onDrag: (d) {
                    setState(() {
                      position = Offset(
                        position.dx + (d.dx / widthFactor),
                        position.dy + (d.dy / heightFactor),
                      );
                    });
                    onUpdate();
                  },
                  onScale: (s) {
                    setState(() => scale = s);
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

class _ResizePoint extends StatelessWidget {
  const _ResizePoint({
    Key? key,
    required this.onDrag,
    this.onScale,
  }) : super(key: key);

  final ValueSetter<Offset> onDrag;
  final ValueSetter<double>? onScale;

  @override
  Widget build(BuildContext context) {
    return _DraggablePoint(
      mode: _PositionMode.local,
      onDrag: onDrag,
      onScale: onScale,
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
    this.onDrag,
    this.onScale,
    this.onRotate,
    this.onTap,
    this.mode = _PositionMode.global,
  }) : super(key: key);

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
  var baseScaleFactor = 1.0;
  var scaleFactor = 1.0;
  var baseAngle = 0.0;
  var angle = 0.0;

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
    Key? key,
    required this.iconData,
    this.onTap,
  }) : super(key: key);

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

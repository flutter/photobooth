part of camera;

typedef PlaceholderBuilder = Widget Function(BuildContext);
typedef PreviewBuilder = Widget Function(BuildContext, Widget);
typedef ErrorBuilder = Widget Function(BuildContext, CameraException);

class Camera extends StatefulWidget {
  Camera({
    Key? key,
    required this.controller,
    PlaceholderBuilder? placeholder,
    PreviewBuilder? preview,
    ErrorBuilder? error,
  })  : placeholder = (placeholder ?? (_) => const SizedBox()),
        preview = (preview ?? (_, preview) => preview),
        error = (error ?? (_, __) => const SizedBox()),
        super(key: key);

  final CameraController controller;
  final PlaceholderBuilder placeholder;
  final PreviewBuilder preview;
  final ErrorBuilder error;

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  Widget? _preview;
  Widget get preview {
    return _preview ??=
        CameraPlatform.instance.buildView(widget.controller.textureId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (BuildContext context, CameraState state, _) {
        switch (state.status) {
          case CameraStatus.uninitialized:
            return widget.placeholder(context);
          case CameraStatus.available:
            return widget.preview(context, preview);
          case CameraStatus.unavailable:
            return widget.error(context, state.error!);
        }
      },
    );
  }
}

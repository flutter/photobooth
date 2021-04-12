import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class PhotoboothPreview extends StatelessWidget {
  const PhotoboothPreview({
    Key? key,
    required this.image,
    required this.preview,
    required this.pose,
    required this.onSnapPressed,
  }) : super(key: key);

  final Widget preview;
  final VoidCallback onSnapPressed;
  final CameraImage? image;
  final posenet.Pose? pose;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    final pose = this.pose;
    final children = <Widget>[
      Flexible(
        child: CharacterIconButton(
          key: const Key(
            'photoboothView_dash_characterIconButton',
          ),
          icon: Image.asset('assets/icons/dash_icon.png'),
          color: PhotoboothColors.lightBlue,
          onPressed: () {
            context.read<PhotoboothBloc>().add(const PhotoboothDashToggled());
          },
        ),
      ),
      const SizedBox(height: 16),
      Flexible(
        child: CharacterIconButton(
          key: const Key(
            'photoboothView_sparky_characterIconButton',
          ),
          icon: Image.asset('assets/icons/sparky_icon.png'),
          color: PhotoboothColors.red,
          onPressed: () {
            context.read<PhotoboothBloc>().add(const PhotoboothSparkyToggled());
          },
        ),
      ),
      const SizedBox(height: 16),
      Flexible(
        child: CharacterIconButton(
          key: const Key(
            'photoboothView_android_characterIconButton',
          ),
          icon: Image.asset('assets/icons/android_icon.png'),
          color: PhotoboothColors.green,
          onPressed: () {
            context
                .read<PhotoboothBloc>()
                .add(const PhotoboothAndroidToggled());
          },
        ),
      ),
    ];
    final state = context.watch<PhotoboothBloc>().state;
    return Center(
      child: Stack(
        fit: StackFit.expand,
        children: [
          preview,
          if (image != null && pose != null)
            CustomPaint(
              key: const Key('photoboothView_posePainter_customPainter'),
              size: Size(image.width.toDouble(), image.height.toDouble()),
              painter: PosePainter(pose: pose, image: Assets.dash.image),
            ),
          ResponsiveLayoutBuilder(
            mobile: (_) => MobileCharactersIconLayout(children: children),
            desktop: (_) => DesktopCharactersIconLayout(children: children),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              key: const Key('photoboothPreview_photo_floatingActionButton'),
              child: const Icon(Icons.photo_camera),
              onPressed: onSnapPressed,
            ),
          ),
          if (state.isAndroidSelected)
            DraggableResizableAsset(
              key: const Key(
                'photoboothPreview_android_draggableResizableAsset',
              ),
              asset: Assets.android,
            ),
          if (state.isDashSelected)
            DraggableResizableAsset(
              key: const Key(
                'photoboothPreview_dash_draggableResizableAsset',
              ),
              asset: Assets.dash,
            ),
          if (state.isSparkySelected)
            DraggableResizableAsset(
              key: const Key(
                'photoboothPreview_sparky_draggableResizableAsset',
              ),
              asset: Assets.sparky,
            ),
        ],
      ),
    );
  }
}

class DesktopCharactersIconLayout extends StatelessWidget {
  const DesktopCharactersIconLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }
}

class MobileCharactersIconLayout extends StatelessWidget {
  const MobileCharactersIconLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class CharacterIconButton extends StatelessWidget {
  const CharacterIconButton({
    Key? key,
    required this.icon,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Widget icon;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          primary: color,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: icon,
        ),
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  const PosePainter({required this.pose, required this.image});

  final posenet.Pose pose;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final positions = pose.toPositions(image: image);
    for (final position in positions) {
      canvas.drawImage(image, position, Paint());
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.pose.score != pose.score;
  }
}

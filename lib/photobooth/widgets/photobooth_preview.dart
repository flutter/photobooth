import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class PhotoboothPreview extends StatelessWidget {
  const PhotoboothPreview({
    Key? key,
    required this.preview,
    required this.onSnapPressed,
  }) : super(key: key);

  final Widget preview;
  final VoidCallback onSnapPressed;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Flexible(
        child: CharacterIconButton(
          key: const Key(
            'photoboothView_dash_characterIconButton',
          ),
          icon: const AssetImage('assets/icons/dash_icon.png'),
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
          icon: const AssetImage('assets/icons/sparky_icon.png'),
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
          icon: const AssetImage('assets/icons/android_icon.png'),
          onPressed: () {
            context
                .read<PhotoboothBloc>()
                .add(const PhotoboothAndroidToggled());
          },
        ),
      ),
    ];
    final state = context.watch<PhotoboothBloc>().state;
    return Stack(
      fit: StackFit.expand,
      children: [
        preview,
        ResponsiveLayoutBuilder(
          mobile: (_) => MobileCharactersIconLayout(children: children),
          desktop: (_) => DesktopCharactersIconLayout(children: children),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ShutterButton(
            key: const Key('photoboothPreview_photo_shutterButton'),
            onCountdownComplete: onSnapPressed,
          ),
        ),
        if (state.android.isSelected)
          DraggableResizableAsset(
            key: const Key(
              'photoboothPreview_android_draggableResizableAsset',
            ),
            asset: Assets.android,
            onUpdate: (update) {
              context
                  .read<PhotoboothBloc>()
                  .add(PhotoboothAndroidUpdated(update: update));
            },
          ),
        if (state.dash.isSelected)
          DraggableResizableAsset(
            key: const Key(
              'photoboothPreview_dash_draggableResizableAsset',
            ),
            asset: Assets.dash,
            onUpdate: (update) {
              context
                  .read<PhotoboothBloc>()
                  .add(PhotoboothDashUpdated(update: update));
            },
          ),
        if (state.sparky.isSelected)
          DraggableResizableAsset(
            key: const Key(
              'photoboothPreview_sparky_draggableResizableAsset',
            ),
            asset: Assets.sparky,
            onUpdate: (update) {
              context
                  .read<PhotoboothBloc>()
                  .add(PhotoboothSparkyUpdated(update: update));
            },
          ),
      ],
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
        mainAxisSize: MainAxisSize.min,
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
    this.onPressed,
  }) : super(key: key);

  final AssetImage icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PhotoboothColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Ink.image(
        fit: BoxFit.cover,
        image: icon,
        width: 120,
        height: 120,
        child: InkWell(onTap: onPressed),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

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
    final state = context.watch<PhotoboothBloc>().state;
    final children = <Widget>[
      Flexible(
        child: CharacterIconButton(
          key: const Key('photoboothView_dash_characterIconButton'),
          icon: const AssetImage('assets/icons/dash_icon.png'),
          isSelected: state.isDashSelected,
          onPressed: () {
            context
                .read<PhotoboothBloc>()
                .add(PhotoCharacterToggled(character: Assets.dash));
          },
        ),
      ),
      const SizedBox(height: 16),
      Flexible(
        child: CharacterIconButton(
          key: const Key('photoboothView_sparky_characterIconButton'),
          icon: const AssetImage('assets/icons/sparky_icon.png'),
          isSelected: state.isSparkySelected,
          onPressed: () {
            context
                .read<PhotoboothBloc>()
                .add(PhotoCharacterToggled(character: Assets.sparky));
          },
        ),
      ),
      const SizedBox(height: 16),
      Flexible(
        child: CharacterIconButton(
          key: const Key('photoboothView_android_characterIconButton'),
          icon: const AssetImage('assets/icons/android_icon.png'),
          isSelected: state.isAndroidSelected,
          onPressed: () {
            context
                .read<PhotoboothBloc>()
                .add(PhotoCharacterToggled(character: Assets.android));
          },
        ),
      ),
    ];
    return Stack(
      fit: StackFit.expand,
      children: [
        preview,
        Positioned.fill(
          child: GestureDetector(
            key: const Key('photoboothPreview_background_gestureDetector'),
            onTap: () {
              context.read<PhotoboothBloc>().add(const PhotoTapped());
            },
          ),
        ),
        const Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 24),
            child: MadeWithIconLinks(),
          ),
        ),
        for (final character in state.characters)
          DraggableResizableAsset(
            key: Key(
              '''photoboothPreview_${character.asset.name}_draggableResizableAsset''',
            ),
            asset: character.asset,
            canTransform: character.id == state.selectedAssetId,
            onUpdate: (update) {
              context.read<PhotoboothBloc>().add(
                    PhotoCharacterDragged(character: character, update: update),
                  );
            },
          ),
        ResponsiveLayoutBuilder(
          mobile: (_) => MobileCharactersIconLayout(children: children),
          desktop: (_) => DesktopCharactersIconLayout(children: children),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ShutterButton(
              key: const Key('photoboothPreview_photo_shutterButton'),
              onCountdownComplete: onSnapPressed,
            ),
          ),
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
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CharactersCaption(),
            const SizedBox(height: 5),
            ...children,
          ],
        ),
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
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
          BlocBuilder<PhotoboothBloc, PhotoboothState>(
            builder: (context, state) {
              if (state.isAnyCharacterSelected) return const SizedBox();
              return const CharactersCaption();
            },
          )
        ],
      ),
    );
  }
}

class CharacterIconButton extends StatelessWidget {
  const CharacterIconButton({
    Key? key,
    required this.icon,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  final AssetImage icon;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const disabledColorFilter = ColorFilter.mode(
      PhotoboothColors.gray,
      BlendMode.saturation,
    );
    return Material(
      color: PhotoboothColors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Ink.image(
        colorFilter: isSelected ? disabledColorFilter : null,
        fit: BoxFit.cover,
        image: icon,
        width: 120,
        height: 120,
        child: InkWell(onTap: onPressed),
      ),
    );
  }
}

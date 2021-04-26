import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/footer/footer.dart';
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
    final state = context.watch<PhotoboothBloc>().state;
    final children = <Widget>[
      CharacterIconButton(
        key: const Key('photoboothView_dash_characterIconButton'),
        icon: const AssetImage('assets/icons/dash_icon.png'),
        isSelected: state.isDashSelected,
        onPressed: () {
          context
              .read<PhotoboothBloc>()
              .add(PhotoCharacterToggled(character: Assets.dash));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_sparky_characterIconButton'),
        icon: const AssetImage('assets/icons/sparky_icon.png'),
        isSelected: state.isSparkySelected,
        onPressed: () {
          context
              .read<PhotoboothBloc>()
              .add(PhotoCharacterToggled(character: Assets.sparky));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_android_characterIconButton'),
        icon: const AssetImage('assets/icons/android_icon.png'),
        isSelected: state.isAndroidSelected,
        onPressed: () {
          context
              .read<PhotoboothBloc>()
              .add(PhotoCharacterToggled(character: Assets.android));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_dino_characterIconButton'),
        icon: const AssetImage('assets/icons/dino_icon.png'),
        isSelected: state.isDinoSelected,
        onPressed: () {
          context
              .read<PhotoboothBloc>()
              .add(PhotoCharacterToggled(character: Assets.dino));
        },
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
          DraggableResizable(
            key: Key(
              '''photoboothPreview_${character.asset.name}_draggableResizableAsset''',
            ),
            canTransform: character.id == state.selectedAssetId,
            onUpdate: (update) {
              context.read<PhotoboothBloc>().add(
                    PhotoCharacterDragged(character: character, update: update),
                  );
            },
            child: _AnimatedCharacter(name: character.asset.name),
          ),
        ResponsiveLayoutBuilder(
          mobile: (_, __) => MobileCharactersIconLayout(children: children),
          desktop: (_, __) => DesktopCharactersIconLayout(children: children),
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

class _AnimatedCharacter extends StatelessWidget {
  const _AnimatedCharacter({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    switch (name) {
      case 'android':
        return const AnimatedAndroid();
      case 'dash':
        return const AnimatedDash();
      case 'dino':
        return const AnimatedDino();
      case 'sparky':
        return const AnimatedSparky();
      default:
        return const SizedBox();
    }
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
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
              ),
            )
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
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
    return Opacity(
      opacity: isSelected ? 0.6 : 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: PhotoboothColors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: Ink.image(
            fit: BoxFit.cover,
            image: icon,
            width: 90,
            height: 90,
            child: InkWell(onTap: onPressed),
          ),
        ),
      ),
    );
  }
}

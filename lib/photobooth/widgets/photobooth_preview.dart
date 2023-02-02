import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _initialCharacterScale = 0.25;
const _minCharacterScale = 0.1;

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
    final l10n = context.l10n;
    final state = context.watch<PhotoboothBloc>().state;
    final children = <Widget>[
      CharacterIconButton(
        key: const Key('photoboothView_dash_characterIconButton'),
        icon: const AssetImage('assets/icons/dash_icon.png'),
        label: l10n.dashButtonLabelText,
        isSelected: state.isDashSelected,
        onPressed: () {
          trackEvent(
            category: 'button',
            action: 'click-add-friend',
            label: 'add-dash-friend',
          );
          context
              .read<PhotoboothBloc>()
              .add(const PhotoCharacterToggled(character: Assets.dash));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_sparky_characterIconButton'),
        icon: const AssetImage('assets/icons/sparky_icon.png'),
        label: l10n.sparkyButtonLabelText,
        isSelected: state.isSparkySelected,
        onPressed: () {
          trackEvent(
            category: 'button',
            action: 'click-add-friend',
            label: 'add-sparky-friend',
          );
          context
              .read<PhotoboothBloc>()
              .add(const PhotoCharacterToggled(character: Assets.sparky));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_android_characterIconButton'),
        icon: const AssetImage('assets/icons/android_icon.png'),
        label: l10n.androidButtonLabelText,
        isSelected: state.isAndroidSelected,
        onPressed: () {
          trackEvent(
            category: 'button',
            action: 'click-add-friend',
            label: 'add-bugdroid-friend',
          );
          context
              .read<PhotoboothBloc>()
              .add(const PhotoCharacterToggled(character: Assets.android));
        },
      ),
      CharacterIconButton(
        key: const Key('photoboothView_dino_characterIconButton'),
        icon: const AssetImage('assets/icons/dino_icon.png'),
        label: l10n.dinoButtonLabelText,
        isSelected: state.isDinoSelected,
        onPressed: () {
          trackEvent(
            category: 'button',
            action: 'click-add-friend',
            label: 'add-dino-friend',
          );
          context
              .read<PhotoboothBloc>()
              .add(const PhotoCharacterToggled(character: Assets.dino));
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
            constraints: _getAnimatedSpriteConstraints(character.asset.name),
            size: _getAnimatedSpriteSize(character.asset.name),
            child: _AnimatedCharacter(name: character.asset.name),
          ),
        CharactersIconLayout(children: children),
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

BoxConstraints? _getAnimatedSpriteConstraints(String name) {
  final sprite = _getAnimatedSprite(name);

  if (sprite == null) return null;

  final size = sprite.sprites.size;
  return BoxConstraints(
    minWidth: size.width * _minCharacterScale,
    minHeight: size.height * _minCharacterScale,
  );
}

Size _getAnimatedSpriteSize(String name) {
  final sprite = _getAnimatedSprite(name);
  if (sprite != null) return sprite.sprites.size * _initialCharacterScale;
  return Size.zero;
}

AnimatedSprite? _getAnimatedSprite(String name) {
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
      return null;
  }
}

class _AnimatedCharacter extends StatelessWidget {
  const _AnimatedCharacter({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return _getAnimatedSprite(name) ?? const SizedBox();
  }
}

class CharactersIconLayout extends StatelessWidget {
  const CharactersIconLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? LandscapeCharactersIconLayout(children: children)
        : PortraitCharactersIconLayout(children: children);
  }
}

@visibleForTesting
class LandscapeCharactersIconLayout extends StatelessWidget {
  const LandscapeCharactersIconLayout({
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

@visibleForTesting
class PortraitCharactersIconLayout extends StatelessWidget {
  const PortraitCharactersIconLayout({
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/assets/assets.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

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
    final isAndroidSelected =
        state.characters.containsCharacter(Character.android);
    final isDashSelected = state.characters.containsCharacter(Character.dash);
    final isSparkySelected =
        state.characters.containsCharacter(Character.sparky);
    final children = <Widget>[
      Flexible(
        child: CharacterIconButton(
          key: const Key('photoboothView_dash_characterIconButton'),
          icon: isDashSelected
              ? const AssetImage('assets/icons/dash_icon_disabled.png')
              : const AssetImage('assets/icons/dash_icon.png'),
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
          key: const Key(
            'photoboothView_sparky_characterIconButton',
          ),
          icon: isSparkySelected
              ? const AssetImage('assets/icons/sparky_icon_disabled.png')
              : const AssetImage('assets/icons/sparky_icon.png'),
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
          key: const Key(
            'photoboothView_android_characterIconButton',
          ),
          icon: isAndroidSelected
              ? const AssetImage('assets/icons/android_icon_disabled.png')
              : const AssetImage('assets/icons/android_icon.png'),
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
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: PhotoboothColors.lightBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                l10n.charactersCaptionText,
                style: const TextStyle(
                  color: PhotoboothColors.white,
                  fontWeight: PhotoboothFontWeight.regular,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
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

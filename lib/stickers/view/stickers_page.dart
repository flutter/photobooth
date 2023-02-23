import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _initialStickerScale = 0.25;
const _minStickerScale = 0.05;

class StickersPage extends StatelessWidget {
  const StickersPage({
    super.key,
  });

  static Route<void> route() {
    return AppPageRoute(builder: (_) => const StickersPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StickersBloc(),
      child: const StickersView(),
    );
  }
}

class StickersView extends StatelessWidget {
  const StickersView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    final image = state.image;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PhotoboothBackground(),
          Center(
            child: AspectRatio(
              aspectRatio: state.aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Positioned.fill(
                    child: ColoredBox(color: PhotoboothColors.black),
                  ),
                  if (image != null) PreviewImage(data: image.data),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 24),
                      child: MadeWithIconLinks(),
                    ),
                  ),
                  const CharactersLayer(),
                  const _DraggableStickers(),
                  const Positioned(
                    left: 15,
                    top: 15,
                    child: Row(
                      children: [
                        _RetakeButton(),
                        ClearStickersButtonLayer(),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: OpenStickersButton(
                      onPressed: () {
                        context
                            .read<StickersBloc>()
                            .add(const StickersDrawerToggled());
                      },
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: _NextButton(),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: _StickerReminderText(),
                  )
                ],
              ),
            ),
          ),
          const StickersDrawerLayer(),
        ],
      ),
    );
  }
}

class _StickerReminderText extends StatelessWidget {
  const _StickerReminderText();
  @override
  Widget build(BuildContext context) {
    final shouldDisplayPropsReminder = context.select(
      (StickersBloc bloc) => bloc.state.shouldDisplayPropsReminder,
    );

    if (!shouldDisplayPropsReminder) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 125),
      child: AppTooltip.custom(
        key: const Key('stickersPage_propsReminder_appTooltip'),
        visible: true,
        message: context.l10n.propsReminderText,
      ),
    );
  }
}

class _DraggableStickers extends StatelessWidget {
  const _DraggableStickers();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    if (state.stickers.isEmpty) return const SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const Key('stickersView_background_gestureDetector'),
            onTap: () {
              context.read<PhotoboothBloc>().add(const PhotoTapped());
            },
          ),
        ),
        for (final sticker in state.stickers)
          DraggableResizable(
            key: Key('stickerPage_${sticker.id}_draggableResizable_asset'),
            canTransform: sticker.id == state.selectedAssetId,
            onUpdate: (update) => context
                .read<PhotoboothBloc>()
                .add(PhotoStickerDragged(sticker: sticker, update: update)),
            onDelete: () => context
                .read<PhotoboothBloc>()
                .add(const PhotoDeleteSelectedStickerTapped()),
            size: sticker.asset.size * _initialStickerScale,
            constraints: sticker.getImageConstraints(),
            child: SizedBox.expand(
              child: Image.asset(
                sticker.asset.path,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
          ),
      ],
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      focusable: true,
      button: true,
      label: l10n.retakePhotoButtonLabelText,
      child: AppTooltipButton(
        key: const Key('stickersPage_retake_appTooltipButton'),
        onPressed: () async {
          final photoboothBloc = context.read<PhotoboothBloc>();
          final navigator = Navigator.of(context);
          final confirmed = await showAppModal<bool>(
            context: context,
            landscapeChild: const _RetakeConfirmationDialogContent(),
            portraitChild: const _RetakeConfirmationBottomSheet(),
          );
          if (confirmed ?? false) {
            photoboothBloc.add(const PhotoClearAllTapped());
            unawaited(
              navigator.pushReplacement(PhotoboothPage.route()),
            );
          }
        },
        verticalOffset: 50,
        message: l10n.retakeButtonTooltip,
        child: Image.asset('assets/icons/retake_button_icon.png', height: 100),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      focusable: true,
      button: true,
      label: l10n.stickersNextButtonLabelText,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: const CircleBorder(),
        color: PhotoboothColors.transparent,
        child: InkWell(
          key: const Key('stickersPage_next_inkWell'),
          onTap: () async {
            final navigator = Navigator.of(context);
            final confirmed = await showAppModal<bool>(
              context: context,
              landscapeChild: const _NextConfirmationDialogContent(),
              portraitChild: const _NextConfirmationBottomSheet(),
            );
            if (confirmed ?? false) {
              unawaited(navigator.pushReplacement(SharePage.route()));
            }
          },
          child: Image.asset(
            'assets/icons/go_next_button_icon.png',
            height: 100,
          ),
        ),
      ),
    );
  }
}

class _RetakeConfirmationDialogContent extends StatelessWidget {
  const _RetakeConfirmationDialogContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.stickersRetakeConfirmationHeading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.stickersRetakeConfirmationSubheading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: PhotoboothColors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      l10n.stickersRetakeConfirmationCancelButtonText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: PhotoboothColors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      l10n.stickersRetakeConfirmationConfirmButtonText,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetakeConfirmationBottomSheet extends StatelessWidget {
  const _RetakeConfirmationBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
        color: PhotoboothColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          const _RetakeConfirmationDialogContent(),
          Positioned(
            right: 24,
            top: 24,
            child: IconButton(
              icon: const Icon(Icons.clear, color: PhotoboothColors.black54),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextConfirmationDialogContent extends StatelessWidget {
  const _NextConfirmationDialogContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.stickersNextConfirmationHeading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.stickersNextConfirmationSubheading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: PhotoboothColors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      l10n.stickersNextConfirmationCancelButtonText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: PhotoboothColors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      l10n.stickersNextConfirmationConfirmButtonText,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextConfirmationBottomSheet extends StatelessWidget {
  const _NextConfirmationBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
        color: PhotoboothColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          const _NextConfirmationDialogContent(),
          Positioned(
            right: 24,
            top: 24,
            child: IconButton(
              icon: const Icon(Icons.clear, color: PhotoboothColors.black54),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
        ],
      ),
    );
  }
}

extension on PhotoAsset {
  BoxConstraints getImageConstraints() {
    return BoxConstraints(
      minWidth: asset.size.width * _minStickerScale,
      minHeight: asset.size.height * _minStickerScale,
    );
  }
}

class OpenStickersButton extends StatefulWidget {
  const OpenStickersButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  State<OpenStickersButton> createState() => _OpenStickersButtonState();
}

class _OpenStickersButtonState extends State<OpenStickersButton> {
  bool _isAnimating = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = Semantics(
      focusable: true,
      button: true,
      label: l10n.addStickersButtonLabelText,
      child: AppTooltipButton(
        key: const Key('stickersView_openStickersButton_appTooltipButton'),
        onPressed: () {
          widget.onPressed();
          if (_isAnimating) setState(() => _isAnimating = false);
        },
        message: l10n.openStickersTooltip,
        verticalOffset: 50,
        child: Image.asset(
          'assets/icons/stickers_button_icon.png',
          height: 100,
        ),
      ),
    );
    return _isAnimating ? AnimatedPulse(child: child) : child;
  }
}

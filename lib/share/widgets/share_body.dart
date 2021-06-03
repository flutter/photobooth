import 'dart:typed_data';
import 'package:analytics/analytics.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
    final file = context.select((ShareBloc bloc) => bloc.state.file);
    final compositeStatus = context.select(
      (ShareBloc bloc) => bloc.state.compositeStatus,
    );
    final compositedImage = context.select(
      (ShareBloc bloc) => bloc.state.bytes,
    );
    final isUploadSuccess = context.select(
      (ShareBloc bloc) => bloc.state.uploadStatus.isSuccess,
    );
    final shareUrl = context.select(
      (ShareBloc bloc) => bloc.state.explicitShareUrl,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AnimatedPhotoIndicator(),
          AnimatedPhotoboothPhoto(image: image),
          if (compositeStatus.isSuccess)
            AnimatedFadeIn(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  isUploadSuccess
                      ? const ShareSuccessHeading()
                      : const ShareHeading(),
                  const SizedBox(height: 20),
                  isUploadSuccess
                      ? const ShareSuccessSubheading()
                      : const ShareSubheading(),
                  const SizedBox(height: 30),
                  if (isUploadSuccess)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        bottom: 30,
                      ),
                      child: ShareCopyableLink(link: shareUrl),
                    ),
                  if (compositedImage != null && file != null)
                    ResponsiveLayoutBuilder(
                      small: (_, __) => MobileButtonsLayout(
                        image: compositedImage,
                        file: file,
                      ),
                      large: (_, __) => DesktopButtonsLayout(
                        image: compositedImage,
                        file: file,
                      ),
                    ),
                  const SizedBox(height: 28),
                  if (isUploadSuccess)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: const ShareSuccessCaption(),
                    ),
                ],
              ),
            ),
          if (compositeStatus.isFailure)
            AnimatedFadeIn(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 20),
                  ShareErrorHeading(),
                  SizedBox(height: 20),
                  ShareErrorSubheading(),
                  SizedBox(height: 30),
                ],
              ),
            )
        ],
      ),
    );
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({
    Key? key,
    required this.image,
    required this.file,
  }) : super(key: key);

  final Uint8List image;
  final XFile file;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: DownloadButton(file: file)),
        const SizedBox(width: 36),
        Flexible(child: ShareButton(image: image)),
        const SizedBox(width: 36),
        const GoToGoogleIOButton(),
      ],
    );
  }
}

@visibleForTesting
class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({
    Key? key,
    required this.image,
    required this.file,
  }) : super(key: key);

  final Uint8List image;
  final XFile file;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DownloadButton(file: file),
        const SizedBox(height: 20),
        ShareButton(image: image),
        const SizedBox(height: 20),
        const GoToGoogleIOButton(),
      ],
    );
  }
}

@visibleForTesting
class GoToGoogleIOButton extends StatelessWidget {
  const GoToGoogleIOButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: PhotoboothColors.white),
      onPressed: launchGoogleIOLink,
      child: Text(
        l10n.goToGoogleIOButtonText,
        style: theme.textTheme.button?.copyWith(color: PhotoboothColors.black),
      ),
    );
  }
}

@visibleForTesting
class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-download-photo',
          label: 'download-photo',
        );
        file.saveTo('');
      },
      child: Text(l10n.sharePageDownloadButtonText),
    );
  }
}

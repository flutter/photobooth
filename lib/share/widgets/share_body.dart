import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareBody extends StatelessWidget {
  const ShareBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
    final isSuccess = context.select(
      (ShareBloc bloc) => bloc.state.uploadStatus.isSuccess,
    );
    final explicitShareUrl = context.select(
      (ShareBloc bloc) => bloc.state.explicitShareUrl,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedPhotoIndicator(),
        AnimatedPhotoboothPhoto(image: image),
        const SizedBox(height: 40),
        isSuccess ? const ShareSuccessHeading() : const ShareHeading(),
        const SizedBox(height: 20),
        isSuccess ? const ShareSuccessSubheading() : const ShareSubheading(),
        const SizedBox(height: 30),
        if (isSuccess)
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: ShareCopyableLink(link: explicitShareUrl),
          ),
        if (image != null)
          ResponsiveLayoutBuilder(
            small: (_, __) => MobileButtonsLayout(image: image),
            large: (_, __) => DesktopButtonsLayout(image: image),
          ),
        const SizedBox(height: 28),
        if (isSuccess) const ShareSuccessCaption(),
      ],
    );
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: DownloadButton()),
        const SizedBox(width: 36),
        Flexible(
          child: ShareButton(
            image: image,
          ),
        ),
        const SizedBox(width: 36),
        const GoToGoogleIOButton(),
      ],
    );
  }
}

@visibleForTesting
class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final gap = const SizedBox(height: 20);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DownloadButton(),
        gap,
        ShareButton(image: image),
        gap,
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
      key: const Key('sharePage_goToGoogleIO_elevatedButton'),
      style: ElevatedButton.styleFrom(
        primary: PhotoboothColors.white,
      ),
      onPressed: launchGoogleIOLink,
      child: Text(
        l10n.goToGoogleIOButtonText,
        style: theme.textTheme.button?.copyWith(
          color: PhotoboothColors.black,
        ),
      ),
    );
  }
}

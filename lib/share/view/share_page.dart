import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SharePage extends StatelessWidget {
  SharePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => ShareBloc(
          delay: const Duration(seconds: 2),
        ),
        child: SharePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
    return Scaffold(
      body: ShareErrorListener(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ShareBackground(),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SharePhoto(image: image),
                      const SizedBox(height: 40),
                      Text(
                        l10n.sharePageHeading,
                        style: theme.textTheme.headline1?.copyWith(
                          color: PhotoboothColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      const LearnMoreAboutText(),
                      const SizedBox(height: 30),
                      if (image != null)
                        ResponsiveLayoutBuilder(
                          mobile: (_) => MobileButtonsLayout(image: image),
                          desktop: (_) => DesktopButtonsLayout(image: image),
                        ),
                      const SizedBox(height: 122),
                      const WhiteFooter()
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 15,
              child: RetakeButton(
                onPressed: () {
                  context
                      .read<PhotoboothBloc>()
                      .add(const PhotoClearAllTapped());
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == PhotoboothPage.name,
                  );
                },
              ),
            ),
            ShareProgressOverlay()
          ],
        ),
      ),
    );
  }
}

class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: _DownloadButton(file: image.toFile())),
        const SizedBox(width: 36),
        Flexible(child: ShareButton(image: image)),
        const SizedBox(width: 36),
        const _GoToGoogleIOButton(),
      ],
    );
  }
}

class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final gap = const SizedBox(height: 20);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DownloadButton(file: image.toFile()),
        gap,
        ShareButton(image: image),
        gap,
        const _GoToGoogleIOButton(),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    Key? key,
    required this.file,
  }) : super(key: key);
  final XFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      key: const Key('sharePage_download_outlinedButton'),
      onPressed: () => file.saveTo(''),
      child: Text(
        l10n.sharePageDownloadButtonText,
      ),
    );
  }
}

class _GoToGoogleIOButton extends StatelessWidget {
  const _GoToGoogleIOButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      key: const Key('sharePage_goToGoogleIO_elevatedButton'),
      style: ElevatedButton.styleFrom(
        primary: PhotoboothColors.white,
      ),
      onPressed: () => '',
      child: Text(
        l10n.goToGoogleIOButtonText,
        style: theme.textTheme.button?.copyWith(
          color: PhotoboothColors.black,
        ),
      ),
    );
  }
}

extension on CameraImage {
  XFile toFile() {
    final uuid = const Uuid().v4();
    return XFile.fromData(
      data,
      mimeType: 'image/png',
      name: 'photobooth_$uuid.png',
    );
  }
}

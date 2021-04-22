import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:io_photobooth/share/view/share_background.dart';
import 'package:io_photobooth/share/view/share_photo.dart';
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ShareBackground(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SharePhoto(),
                    const SizedBox(height: 40),
                    Text(
                      l10n.sharePageHeading,
                      style: theme.textTheme.headline1?.copyWith(
                        color: PhotoboothColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    if (image != null)
                      ResponsiveLayoutBuilder(
                        mobile: (_) => MobileButtonsLayout(image: image),
                        desktop: (_) => DesktopButtonsLayout(image: image),
                      ),
                    const SizedBox(height: 42),
                    _SocialMediaShareClarificationNote(
                      key: const Key('sharePage_socialMediaShareClarification'),
                    ),
                    const SizedBox(height: 80),
                    const WhiteFooter()
                  ],
                ),
              ),
            ),
          ),
          ShareProgressOverlay()
        ],
      ),
    );
  }
}

class _SocialMediaShareClarificationNote extends StatelessWidget {
  _SocialMediaShareClarificationNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final text = Text(
      l10n.sharePageSocialMediaShareClarification,
      key: const Key(
        'sharePage_socialMediaShareClarification_text',
      ),
      textAlign: TextAlign.center,
      style: theme.textTheme.caption?.copyWith(
        color: PhotoboothColors.white,
        fontWeight: PhotoboothFontWeight.regular,
      ),
    );

    return ResponsiveLayoutBuilder(
      mobile: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: text,
      ),
      desktop: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 234),
        child: text,
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
        const Flexible(child: _RetakeButton()),
        const SizedBox(width: 36),
        Flexible(child: ShareButton(image: image)),
        const SizedBox(width: 36),
        Flexible(child: _DownloadButton(file: image.toFile())),
      ],
    );
  }
}

class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _RetakeButton(),
        const SizedBox(height: 15),
        ShareButton(image: image),
        const SizedBox(height: 20),
        _DownloadButton(file: image.toFile()),
      ],
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      key: const Key('sharePage_retake_elevatedButton'),
      onPressed: () {
        context.read<PhotoboothBloc>().add(const PhotoClearAllTapped());
        Navigator.of(context).popUntil(
          (route) => route.settings.name == PhotoboothPage.name,
        );
      },
      child: Text(l10n.sharePageRetakeButtonText),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      key: const Key('sharePage_download_elevatedButton'),
      style: ElevatedButton.styleFrom(
        primary: PhotoboothColors.white,
      ),
      onPressed: () => file.saveTo(''),
      child: Text(
        l10n.sharePageDownloadButtonText,
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

import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:provider/provider.dart';

const _photoImageHeight = 500.0;

class SharePage extends StatelessWidget {
  SharePage({
    Key? key,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  static Route route() {
    return MaterialPageRoute(builder: (_) => SharePage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);

    return Provider.value(
      value: platformHelper,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/backgrounds/share_background.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (image != null)
                      Container(
                        height: _photoImageHeight,
                        child: PhotoboothPhoto(image: image.data),
                      ),
                    const SizedBox(height: 80),
                    Text(
                      l10n.sharePageHeading,
                      style: theme.textTheme.headline1
                          ?.copyWith(color: PhotoboothColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sharePageSubheading,
                      style: theme.textTheme.headline2
                          ?.copyWith(color: PhotoboothColors.white),
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
          ],
        ),
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
        Flexible(child: _ShareButton(image: image)),
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
        _ShareButton(image: image),
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

class _ShareButton extends StatelessWidget {
  const _ShareButton({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('sharePage_share_elevatedButton'),
      onPressed: () {
        final platform = context.read<PlatformHelper>();
        if (platform.isMobile) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<PhotoboothBloc>(),
              child: ShareBottomSheet(image: image),
            ),
          );
        } else {
          showDialog(
            barrierColor: PhotoboothColors.dialogBarrierColor,
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<PhotoboothBloc>(),
              child: ShareDialog(image: image),
            ),
          );
        }
      },
      child: Text(l10n.sharePageShareButtonText),
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

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/app/app.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:uuid/uuid.dart';

import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  static Route route({
    required CameraImage image,
    required PhotoboothBloc photoboothBloc,
  }) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: photoboothBloc,
        child: SharePage(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgrounds/share_background.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Photo(image: image.data),
                    const SizedBox(height: 24),
                    Text(
                      l10n.previewPageHeading,
                      style: theme.textTheme.headline1
                          ?.copyWith(color: PhotoboothColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.previewPageSubheading,
                      style: theme.textTheme.headline2
                          ?.copyWith(color: PhotoboothColors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ResponsiveLayoutBuilder(
                      mobile: (_) => MobileButtonsLayout(image: image),
                      desktop: (_) => DesktopButtonsLayout(image: image),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WhiteFooter(),
          ),
        ],
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

class _Photo extends StatelessWidget {
  const _Photo({Key? key, required this.image}) : super(key: key);

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    final targetRatio = isMobile ? 3 / 4 : 4 / 3;
    return FractionallySizedBox(
      widthFactor: 0.4,
      child: AspectRatio(
        aspectRatio: targetRatio,
        child: Transform.rotate(
          angle: -11 * (math.pi / 180),
          child: Material(
            elevation: 4,
            color: PhotoboothColors.white,
            child: AspectRatio(
              aspectRatio: targetRatio,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: PreviewImage(data: image),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('sharePage_retake_elevatedButton'),
      onPressed: () {
        context.read<PhotoboothBloc>().add(const PhotoboothCharactersCleared());
        Navigator.of(context).popUntil(
          (route) => route.settings.name == PhotoboothPage.name,
        );
      },
      child: Text(l10n.previewPageRetakeButtonText),
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
        showDialog(
          barrierColor: PhotoboothColors.gray.withOpacity(0.75),
          context: context,
          builder: (_) => ShareDialog(image: image),
        );
      },
      child: Text(l10n.previewPageShareButtonText),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('sharePage_download_elevatedButton'),
      onPressed: () => file.saveTo(''),
      child: Text(l10n.previewPageDownloadButtonText),
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

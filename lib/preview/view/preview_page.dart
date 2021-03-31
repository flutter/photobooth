import 'dart:typed_data';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  static Route route({required CameraImage image}) {
    return MaterialPageRoute(builder: (_) => PreviewPage(image: image));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    print(image.height);
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 50),
                  PreviewImage(
                    image: image,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.previewPageHeading,
                    style: theme.textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.previewPageSubheading,
                    style: theme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  const ButtonsLayout(),
                ],
              ),
            ),
          ),
        ));
  }
}

class PreviewImage extends StatelessWidget {
  const PreviewImage({Key? key, required this.image}) : super(key: key);

  final CameraImage image;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -15 / 360,
      child: Image.memory(
        Uint8List.fromList(image.imageData.decoded),
        isAntiAlias: true,
        errorBuilder: (context, error, stackTrace) {
          return Text('Error, $error, $stackTrace');
        },
      ),
    );
  }
}

@visibleForTesting
class ButtonsLayout extends StatelessWidget {
  const ButtonsLayout({Key? key}) : super(key: key);
  static const int mobileBreakpoint = 600;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= mobileBreakpoint)
          return const MobileButtonsLayout();
        return const DesktopButtonsLayout();
      },
    );
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RetakeButton(),
        const SizedBox(
          width: 70,
        ),
        const ShareButton(),
        const SizedBox(
          width: 70,
        ),
        const DownloadButton(),
      ],
    );
  }
}

@visibleForTesting
class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RetakeButton(),
        const SizedBox(
          height: 15,
        ),
        const ShareButton(),
        const SizedBox(
          height: 20,
        ),
        const DownloadButton(),
      ],
    );
  }
}

@visibleForTesting
class RetakeButton extends StatelessWidget {
  const RetakeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      child: Text(l10n.previewPageRetakeButtonText),
      onPressed: () => print(''),
    );
  }
}

@visibleForTesting
class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      child: Text(l10n.previewPageShareButtonText),
      onPressed: () => print(''),
    );
  }
}

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      child: Text(l10n.previewPageDownloadButtonText),
      onPressed: () => print(''),
    );
  }
}

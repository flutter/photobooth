import 'package:io_photobooth/l10n/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:io_photobooth/preview/view/share_dialog.dart';

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
                  ButtonsLayout(
                    cameraImage: image,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

@visibleForTesting
class ButtonsLayout extends StatelessWidget {
  const ButtonsLayout({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);
  final CameraImage cameraImage;
  static const int mobileBreakpoint = 600;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= mobileBreakpoint)
          return MobileButtonsLayout(
            cameraImage: cameraImage,
          );
        return DesktopButtonsLayout(
          cameraImage: cameraImage,
        );
      },
    );
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);

  final CameraImage cameraImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RetakeButton(),
        const SizedBox(
          width: 70,
        ),
        ShareButton(
          cameraImage: cameraImage,
        ),
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
  const MobileButtonsLayout({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);

  final CameraImage cameraImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RetakeButton(),
        const SizedBox(
          height: 15,
        ),
        ShareButton(
          cameraImage: cameraImage,
        ),
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
  const RetakeButton({
    Key? key,
  }) : super(key: key);

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
  const ShareButton({
    Key? key,
    required this.cameraImage,
  }) : super(key: key);

  final CameraImage cameraImage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      child: Text(l10n.previewPageShareButtonText),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ShareDialog(
            cameraImage: cameraImage,
          ),
        );
      },
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
      onPressed: () {},
    );
  }
}

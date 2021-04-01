import 'package:io_photobooth/l10n/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/preview/preview.dart';

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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PreviewImage(image: image),
                  const SizedBox(height: 24),
                  Text(
                    l10n.previewPageHeading,
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.previewPageSubheading,
                    style: theme.textTheme.headline2,
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
        const Flexible(child: RetakeButton()),
        const SizedBox(
          width: 36,
        ),
        Flexible(
          child: ShareButton(
            cameraImage: cameraImage,
          ),
        ),
        const SizedBox(
          width: 36,
        ),
        const Flexible(child: DownloadButton()),
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

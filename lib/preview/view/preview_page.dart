import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  final ImageData image;

  static Route route({required ImageData image}) {
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
                  ResponsiveLayoutBuilder(
                    mobile: (_) => MobileButtonsLayout(image: image),
                    desktop: (_) => DesktopButtonsLayout(image: image),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

@visibleForTesting
class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: RetakeButton()),
        const SizedBox(width: 36),
        Flexible(child: ShareButton(image: image)),
        const SizedBox(width: 36),
        Flexible(child: DownloadButton(file: image.toFile())),
      ],
    );
  }
}

@visibleForTesting
class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RetakeButton(),
        const SizedBox(height: 15),
        ShareButton(image: image),
        const SizedBox(height: 20),
        DownloadButton(file: image.toFile()),
      ],
    );
  }
}

extension on ImageData {
  XFile toFile() {
    return XFile.fromData(data, mimeType: 'image/png', name: 'photobooth.png');
  }
}

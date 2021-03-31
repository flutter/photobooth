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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                Transform.rotate(
                  angle: -15 / 360,
                  child: Image.memory(
                    Uint8List.fromList(image.imageData.decoded),
                    isAntiAlias: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error, $error, $stackTrace');
                    },
                  ),
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
                _ButtonsLayout(),
              ],
            ),
          ),
        ));
  }
}

class _ButtonsLayout extends StatelessWidget {
  const _ButtonsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(l10n.previewPageRetakeButtonText),
          onPressed: () => print(''),
        ),
        const SizedBox(
          width: 70,
        ),
        ElevatedButton(
          child: Text(l10n.previewPageShareButtonText),
          onPressed: () => print(''),
        ),
        const SizedBox(
          width: 70,
        ),
        ElevatedButton(
          child: Text(l10n.previewPageDownloadButtonText),
          onPressed: () => print(''),
        ),
      ],
    );
  }
}

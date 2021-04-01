import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key, required this.url}) : super(key: key);

  final Uri url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      child: Text(l10n.previewPageDownloadButtonText),
      onPressed: () async {
        try {
          await launch(
            url.toString(),
            headers: {
              'Content-Disposition': 'attachment',
              'filename': 'photobooth.png',
            },
            webOnlyWindowName: '_self',
          );
        } catch (_) {}
      },
    );
  }
}

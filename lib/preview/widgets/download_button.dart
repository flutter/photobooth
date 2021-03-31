import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

//TODO: move to package
class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 208,
        height: 54,
      ),
      child: ElevatedButton(
        child: Text(l10n.previewPageDownloadButtonText),
        onPressed: () {},
      ),
    );
  }
}

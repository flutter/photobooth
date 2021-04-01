import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:file_selector/file_selector.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key, required this.file}) : super(key: key);

  final XFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      child: Text(l10n.previewPageDownloadButtonText),
      onPressed: () => file.saveTo(''),
    );
  }
}

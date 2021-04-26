import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';

class TwitterButton extends StatelessWidget {
  const TwitterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        final photoboothState = context.read<PhotoboothBloc>().state;

        final photoboothImage = photoboothState.image;
        final photoboothAssets = photoboothState.assets;

        if (photoboothImage == null) {
          return;
        }

        context.read<ShareBloc>().add(
              ShareOnTwitter(
                image: photoboothImage,
                assets: photoboothAssets,
              ),
            );

        Navigator.of(context).pop();
      },
      child: Text(l10n.shareDialogTwitterButtonText),
    );
  }
}

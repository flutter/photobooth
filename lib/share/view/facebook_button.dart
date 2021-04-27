import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () {
        final photoboothState = context.read<PhotoboothBloc>().state;

        final photoboothImage = photoboothState.image;
        final photoboothImageName = photoboothState.imageName;
        final photoboothAssets = photoboothState.assets;

        if (photoboothImage == null || photoboothImageName == null) {
          return;
        }

        context.read<ShareBloc>().add(
              ShareOnFacebook(
                image: photoboothImage,
                imageName: photoboothImageName,
                assets: photoboothAssets,
                shareText: l10n.socialMediaShareLinkText,
              ),
            );

        Navigator.of(context).pop();
      },
      child: Text(l10n.shareDialogFacebookButtonText),
    );
  }
}

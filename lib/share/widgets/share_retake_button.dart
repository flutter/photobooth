import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:provider/provider.dart';

/// A button displayed in the top left corner of the [SharePage].
///
/// It adds a [PhotoClearAllTapped] event to the [PhotoboothBloc]
/// and navigates back to the [PhotoboothPage].
class ShareRetakeButton extends StatelessWidget {
  const ShareRetakeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: 15,
      child: RetakeButton(
        onPressed: () {
          context.read<PhotoboothBloc>().add(const PhotoClearAllTapped());
          Navigator.of(context)
              .popUntil((route) => route.settings.name == PhotoboothPage.name);
        },
      ),
    );
  }
}

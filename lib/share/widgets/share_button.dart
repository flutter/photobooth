import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:provider/provider.dart';

class ShareButton extends StatelessWidget {
  ShareButton({
    Key? key,
    required this.image,
    required this.aspectRatio,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// Raw image from camera
  final CameraImage image;

  final double aspectRatio;

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('sharePage_share_elevatedButton'),
      onPressed: () {
        if (platformHelper.isMobile ||
            aspectRatio == PhotoboothAspectRatio.portrait) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: PhotoboothColors.transparent,
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<PhotoboothBloc>()),
                BlocProvider.value(value: context.read<ShareBloc>()),
              ],
              child: ShareBottomSheet(image: image),
            ),
          );
        } else {
          showAppDialog(
            context: context,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<PhotoboothBloc>()),
                BlocProvider.value(value: context.read<ShareBloc>()),
              ],
              child: ShareDialog(
                aspectRatio: PhotoboothAspectRatio.landscape,
                image: image,
              ),
            ),
          );
        }
      },
      child: Text(l10n.sharePageShareButtonText),
    );
  }
}

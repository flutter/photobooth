import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareErrorListener extends StatelessWidget {
  ShareErrorListener({
    Key? key,
    PlatformHelper? platformHelper,
    required this.child,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  final Widget child;

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareBloc, ShareState>(
      listenWhen: (prev, next) => next.status == ShareStatus.error,
      listener: _onShareError,
      child: child,
    );
  }

  void _onShareError(BuildContext context, ShareState state) {
    if (platformHelper.isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const ShareErrorBottomSheet(),
      );
    } else {
      showDialog(
        barrierColor: PhotoboothColors.dialogBarrierColor,
        context: context,
        builder: (_) => const ShareErrorDialog(),
      );
    }
  }
}

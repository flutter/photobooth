import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

class ShareStateListener extends StatelessWidget {
  ShareStateListener({
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
      listener: _onShareStateChange,
      child: child,
    );
  }

  void _onShareStateChange(BuildContext context, ShareState state) {
    if (state.uploadStatus.isFailure) {
      _onShareError(context, state);
    } else if (state.uploadStatus.isSuccess) {
      _onShareSuccess(context, state);
    }
  }

  void _onShareError(BuildContext context, ShareState state) {
    showAppModal<void>(
      platformHelper: platformHelper,
      context: context,
      portraitChild: const ShareErrorBottomSheet(),
      landscapeChild: const ShareErrorDialog(),
    );
  }

  void _onShareSuccess(BuildContext context, ShareState state) {
    openLink(
      state.shareUrl == ShareUrl.twitter
          ? state.twitterShareUrl
          : state.facebookShareUrl,
    );
  }
}

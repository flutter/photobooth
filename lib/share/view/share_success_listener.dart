import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class ShareSuccessListener extends StatelessWidget {
  ShareSuccessListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareBloc, ShareState>(
      listenWhen: (prev, next) => next.status == ShareStatus.success,
      listener: _onShareSuccess,
      child: child,
    );
  }

  void _onShareSuccess(BuildContext context, ShareState state) {
    openLink(state.shareUrl);
  }
}

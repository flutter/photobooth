import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Overlay displayed on top of the [SharePage] when [ShareBloc] is
/// in the [ShareStatus.loading] state.
class ShareProgressOverlay extends StatelessWidget {
  ShareProgressOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareBloc, ShareState>(
      builder: (context, state) => state.status == ShareStatus.loading
          ? _ShareProgressOverlay(
              key: const Key('shareProgressOverlay_loading'),
            )
          : _Nothing(
              key: const Key('shareProgressOverlay_nothing'),
            ),
    );
  }
}

class _ShareProgressOverlay extends StatelessWidget {
  _ShareProgressOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PhotoboothColors.black54,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _Nothing extends StatelessWidget {
  _Nothing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:provider/provider.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  static Route route() {
    return AppPageRoute(builder: (_) => const SharePage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
      create: (context) {
        final state = context.read<PhotoboothBloc>().state;
        return ShareBloc(
          photosRepository: context.read<PhotosRepository>(),
          imageId: state.imageId,
          image: state.image!,
          assets: state.assets,
          aspectRatio: state.aspectRatio,
          shareText: l10n.socialMediaShareLinkText,
        )..add(const ShareViewLoaded());
      },
      child: const ShareView(),
    );
  }
}

class ShareView extends StatelessWidget {
  const ShareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShareStateListener(
        child: const AppPageView(
          background: ShareBackground(),
          body: ShareBody(),
          footer: WhiteFooter(),
          overlays: [
            ShareRetakeButton(),
            ShareProgressOverlay(),
          ],
        ),
      ),
    );
  }
}

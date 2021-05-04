import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/external_links/external_links.dart';
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
    return MaterialPageRoute(builder: (_) => const SharePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final state = context.read<PhotoboothBloc>().state;
        return ShareBloc(
          photosRepository: context.read<PhotosRepository>(),
          imageId: state.imageId,
          image: state.image!,
          assets: state.assets,
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
    final image = context.select((PhotoboothBloc bloc) => bloc.state.image);
    return Scaffold(
      body: ShareStateListener(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ShareBackground(),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedPhotoIndicator(),
                    AnimatedPhotoboothPhoto(image: image),
                    const SizedBox(height: 40),
                    const _Heading(),
                    const SizedBox(height: 20),
                    const LearnMoreAboutText(),
                    const SizedBox(height: 30),
                    if (image != null)
                      ResponsiveLayoutBuilder(
                        small: (_, __) => MobileButtonsLayout(image: image),
                        large: (_, __) => DesktopButtonsLayout(
                          image: image,
                        ),
                      ),
                    const SizedBox(height: 70),
                    const WhiteFooter()
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 15,
              child: RetakeButton(
                onPressed: () {
                  context
                      .read<PhotoboothBloc>()
                      .add(const PhotoClearAllTapped());
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == PhotoboothPage.name,
                  );
                },
              ),
            ),
            ShareProgressOverlay()
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Text(
      l10n.sharePageHeading,
      style: theme.textTheme.headline1?.copyWith(
        color: PhotoboothColors.white,
        fontSize:
            MediaQuery.of(context).size.width > PhotoboothBreakpoints.small
                ? 56
                : 32,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class DesktopButtonsLayout extends StatelessWidget {
  const DesktopButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: DownloadButton()),
        const SizedBox(width: 36),
        Flexible(child: ShareButton(image: image)),
        const SizedBox(width: 36),
        const _GoToGoogleIOButton(),
      ],
    );
  }
}

class MobileButtonsLayout extends StatelessWidget {
  const MobileButtonsLayout({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  Widget build(BuildContext context) {
    final gap = const SizedBox(height: 20);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const DownloadButton(),
        gap,
        ShareButton(image: image),
        gap,
        const _GoToGoogleIOButton(),
      ],
    );
  }
}

class _GoToGoogleIOButton extends StatelessWidget {
  const _GoToGoogleIOButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ElevatedButton(
      key: const Key('sharePage_goToGoogleIO_elevatedButton'),
      style: ElevatedButton.styleFrom(
        primary: PhotoboothColors.white,
      ),
      onPressed: launchGoogleIOLink,
      child: Text(
        l10n.goToGoogleIOButtonText,
        style: theme.textTheme.button?.copyWith(
          color: PhotoboothColors.black,
        ),
      ),
    );
  }
}

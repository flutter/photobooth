import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/common/common.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:provider/provider.dart';
import 'package:share_photo_repository/share_photo_repository.dart';

class SharePage extends StatelessWidget {
  SharePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => ShareBloc(
          sharePhotoRepository: context.read<SharePhotoRepository>(),
          photosRepository: context.read<PhotosRepository>(),
        ),
        child: SharePage(),
      ),
    );
  }

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
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
                          mobile: (_, __) => MobileButtonsLayout(image: image),
                          desktop: (_, __) => DesktopButtonsLayout(
                            image: image,
                          ),
                        ),
                      const SizedBox(height: 70),
                      const WhiteFooter()
                    ],
                  ),
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
            MediaQuery.of(context).size.width > PhotoboothBreakpoints.mobile
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
        Flexible(child: _DownloadButton(image: image)),
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
        _DownloadButton(image: image),
        gap,
        ShareButton(image: image),
        gap,
        const _GoToGoogleIOButton(),
      ],
    );
  }
}

class _DownloadButton extends StatefulWidget {
  const _DownloadButton({Key? key, required this.image}) : super(key: key);

  final CameraImage image;

  @override
  __DownloadButtonState createState() => __DownloadButtonState();
}

class __DownloadButtonState extends State<_DownloadButton> {
  var _isLoading = false;
  final _compositor = ImageCompositor();

  void _onPressed() async {
    final state = context.read<PhotoboothBloc>().state;
    final layers = [...state.characters, ...state.stickers];
    setState(() => _isLoading = true);
    final result = await _compositor.composite(
      data: widget.image.data,
      width: widget.image.width,
      height: widget.image.height,
      layers: layers
          .map(
            (c) => CompositeLayer(
              angle: c.angle,
              position: Vector2D(c.position.dx, c.position.dy),
              size: Vector2D(c.size.width, c.size.height),
              scale: c.scale,
              assetPath: 'assets/${c.asset.path}',
            ).toJson(),
          )
          .toList(),
    );
    setState(() => _isLoading = false);
    final file = XFile.fromData(
      Uint8List.fromList(result),
      mimeType: 'image/png',
      name: 'photobooth.png',
    );
    await file.saveTo('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton(
      key: const Key('sharePage_download_outlinedButton'),
      onPressed: _onPressed,
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(l10n.sharePageDownloadButtonText),
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

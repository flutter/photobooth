import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({Key? key, required this.error}) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        const PermissionsBackground(),
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.width > PhotoboothBreakpoints.small
                      ? size.height * 0.4
                      : 0,
                ),
                _PhotoboothCameraError(error: error),
                SizedBox(
                  height: size.height * 0.4,
                ),
                const WhiteFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoboothCameraError extends StatelessWidget {
  const _PhotoboothCameraError({
    Key? key,
    required this.error,
  }) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    if (error is CameraNotAllowedException) {
      return _PhotoboothCameraAccessDeniedError(
        key: const Key('photoboothError_cameraAccessDenied'),
      );
    }

    if (error is CameraNotFoundException) {
      return _PhotoboothCameraNotFoundError(
        key: const Key('photoboothError_cameraNotFound'),
      );
    }

    return _PhotoboothCameraUnknownError(
      key: const Key('photoboothError_unknown'),
    );
  }
}

class _PhotoboothCameraAccessDeniedError extends StatelessWidget {
  _PhotoboothCameraAccessDeniedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          l10n.photoBoothCameraAccessDeniedHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraAccessDeniedSubheadline,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraNotFoundError extends StatelessWidget {
  _PhotoboothCameraNotFoundError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          l10n.photoBoothCameraNotFoundHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotFoundSubheadline1,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotFoundSubheadline2,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraUnknownError extends StatelessWidget {
  _PhotoboothCameraUnknownError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(
          l10n.photoBoothCameraErrorHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraErrorSubheadline1,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraErrorSubheadline2,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

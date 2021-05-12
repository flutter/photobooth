import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PhotoboothError extends StatelessWidget {
  const PhotoboothError({Key? key, required this.error}) : super(key: key);

  final CameraException error;

  @override
  Widget build(BuildContext context) {
    if (error is CameraNotAllowedException) {
      return const _PhotoboothCameraAccessDeniedError(
        key: Key('photoboothError_cameraAccessDenied'),
      );
    }

    if (error is CameraNotFoundException) {
      return const _PhotoboothCameraNotFoundError(
        key: Key('photoboothError_cameraNotFound'),
      );
    }

    if (error is CameraNotSupportedException) {
      return const _PhotoboothCameraNotSupportedError(
        key: Key('photoboothError_cameraNotSupported'),
      );
    }

    return const _PhotoboothCameraUnknownError(
      key: Key('photoboothError_unknown'),
    );
  }
}

class _PhotoboothCameraAccessDeniedError extends StatelessWidget {
  const _PhotoboothCameraAccessDeniedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
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
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraNotFoundError extends StatelessWidget {
  const _PhotoboothCameraNotFoundError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
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
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotFoundSubheadline2,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraUnknownError extends StatelessWidget {
  const _PhotoboothCameraUnknownError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
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
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraErrorSubheadline2,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothCameraNotSupportedError extends StatelessWidget {
  const _PhotoboothCameraNotSupportedError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _PhotoboothErrorContent(
      children: [
        SelectableText(
          l10n.photoBoothCameraNotSupportedHeadline,
          style: theme.textTheme.headline1?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SelectableText(
          l10n.photoBoothCameraNotSupportedSubheadline,
          style: theme.textTheme.headline3?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _PhotoboothErrorContent extends StatelessWidget {
  const _PhotoboothErrorContent({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

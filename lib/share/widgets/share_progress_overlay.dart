import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Overlay displayed on top of the [SharePage] when [ShareBloc] is
/// in the in progress state.
class ShareProgressOverlay extends StatelessWidget {
  const ShareProgressOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareBloc, ShareState>(
      builder: (context, state) => state.uploadStatus.isLoading ||
              (state.compositeStatus.isLoading && state.isUploadRequested)
          ? const _ShareProgressOverlay(
              key: Key('shareProgressOverlay_loading'),
            )
          : const SizedBox(key: Key('shareProgressOverlay_nothing')),
    );
  }
}

class _ShareProgressOverlay extends StatelessWidget {
  const _ShareProgressOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PhotoboothColors.black.withOpacity(0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: ResponsiveLayoutBuilder(
            small: (_, __) => const _MobileShareProgressOverlay(
              key: Key('shareProgressOverlay_mobile'),
            ),
            large: (_, __) => const _DesktopShareProgressOverlay(
              key: Key('shareProgressOverlay_desktop'),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopShareProgressOverlay extends StatelessWidget {
  const _DesktopShareProgressOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: PhotoboothColors.orange,
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 258),
          child: Text(
            l10n.sharePageProgressOverlayHeading,
            style: theme.textTheme.displayLarge?.copyWith(
              color: PhotoboothColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.sharePageProgressOverlaySubheading,
          style: theme.textTheme.displaySmall?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MobileShareProgressOverlay extends StatelessWidget {
  const _MobileShareProgressOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppCircularProgressIndicator(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.sharePageProgressOverlayHeading,
            style: theme.textTheme.displayLarge?.copyWith(
              color: PhotoboothColors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          l10n.sharePageProgressOverlaySubheading,
          style: theme.textTheme.displaySmall?.copyWith(
            color: PhotoboothColors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

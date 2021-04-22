import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:io_photobooth/l10n/l10n.dart';

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
          : const SizedBox(
              key: Key('shareProgressOverlay_nothing'),
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
      color: PhotoboothColors.black.withOpacity(0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: ResponsiveLayoutBuilder(
            mobile: (_) => _MobileShareProgressOverlay(
              key: const Key('shareProgressOverlay_mobile'),
            ),
            desktop: (_) => _DesktopShareProgressOverlay(
              key: const Key('shareProgressOverlay_desktop'),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopShareProgressOverlay extends StatelessWidget {
  _DesktopShareProgressOverlay({
    Key? key,
  }) : super(key: key);

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
            style: theme.textTheme.headline1?.copyWith(
              color: PhotoboothColors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          l10n.sharePageProgressOverlaySubheading,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MobileShareProgressOverlay extends StatelessWidget {
  _MobileShareProgressOverlay({
    Key? key,
  }) : super(key: key);

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
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.sharePageProgressOverlayHeading,
            style: theme.textTheme.headline1?.copyWith(
              color: PhotoboothColors.white,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          l10n.sharePageProgressOverlaySubheading,
          style: theme.textTheme.headline2?.copyWith(
            color: PhotoboothColors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

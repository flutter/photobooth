import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photos_repository/photos_repository.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  static Route<void> route() {
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
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShareStateListener(
        child: const AppPageView(
          background: ShareBackground(),
          body: ShareBody(),
          footer: WhiteFooter(),
          overlays: [
            _ShareRetakeButton(),
            ShareProgressOverlay(),
          ],
        ),
      ),
    );
  }
}

class _ShareRetakeButton extends StatelessWidget {
  const _ShareRetakeButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select(
      (ShareBloc bloc) => bloc.state.compositeStatus.isLoading,
    );
    if (isLoading) return const SizedBox();
    return Positioned(
      left: 15,
      top: 15,
      child: Semantics(
        focusable: true,
        button: true,
        label: l10n.retakePhotoButtonLabelText,
        child: AppTooltipButton(
          key: const Key('sharePage_retake_appTooltipButton'),
          onPressed: () async {
            final photoboothBloc = context.read<PhotoboothBloc>();
            final navigator = Navigator.of(context);
            final confirmed = await showAppModal<bool>(
              context: context,
              landscapeChild: const _ConfirmationDialogContent(),
              portraitChild: const _ConfirmationBottomSheet(),
            );
            if (confirmed ?? false) {
              photoboothBloc.add(const PhotoClearAllTapped());
              unawaited(navigator.pushReplacement(PhotoboothPage.route()));
            }
          },
          verticalOffset: 50,
          message: l10n.retakeButtonTooltip,
          child: Image.asset(
            'assets/icons/retake_button_icon.png',
            height: 100,
          ),
        ),
      ),
    );
  }
}

class _ConfirmationDialogContent extends StatelessWidget {
  const _ConfirmationDialogContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.shareRetakeConfirmationHeading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.shareRetakeConfirmationSubheading,
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 24,
                children: [
                  OutlinedButton(
                    key: const Key('sharePage_retakeCancel_elevatedButton'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: PhotoboothColors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      l10n.shareRetakeConfirmationCancelButtonText,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: PhotoboothColors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('sharePage_retakeConfirm_elevatedButton'),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.shareRetakeConfirmationConfirmButtonText),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmationBottomSheet extends StatelessWidget {
  const _ConfirmationBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
        color: PhotoboothColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          const _ConfirmationDialogContent(),
          Positioned(
            right: 24,
            top: 24,
            child: IconButton(
              icon: const Icon(Icons.clear, color: PhotoboothColors.black54),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
        ],
      ),
    );
  }
}

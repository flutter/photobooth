import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PhotoboothColors.white,
      body: LandingView(),
    );
  }
}

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          key: const Key('landingPage_background'),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PhotoboothColors.gray,
                PhotoboothColors.white,
              ],
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 24),
                  SelectableText(
                    l10n.landingPageHeading,
                    key: const Key('landingPage_heading_text'),
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SelectableText(
                    l10n.landingPageSubheading,
                    key: const Key('landingPage_subheading_text'),
                    style: theme.textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const TakePhotoButton(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Image.asset(
                      'assets/backgrounds/landing_background.png',
                      height: size.width > PhotoboothBreakpoints.small
                          ? size.height * 0.6
                          : size.height * 0.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const BlackFooter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TakePhotoButton extends StatelessWidget {
  const TakePhotoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      onPressed: () => Navigator.of(context).push(PhotoboothPage.route()),
      child: Text(l10n.landingPageTakePhotoButtonText),
    );
  }
}

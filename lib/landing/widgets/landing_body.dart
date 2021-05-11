import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          SelectableText(
            l10n.landingPageHeading,
            key: const Key('landingPage_heading_text'),
            style: theme.textTheme.headline1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SelectableText(
            l10n.landingPageSubheading,
            key: const Key('landingPage_subheading_text'),
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const LandingTakePhotoButton(),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Image.asset(
              'assets/backgrounds/landing_background.png',
              height: size.width <= PhotoboothBreakpoints.small
                  ? size.height * 0.4
                  : size.height * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

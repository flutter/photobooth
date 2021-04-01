import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.landingPageHeading,
              style: theme.textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.landingPageSubheading,
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const TakePhotoButton(),
          ],
        ),
      ),
    );
  }
}

class TakePhotoButton extends StatelessWidget {
  const TakePhotoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ElevatedButton(
      child: Text(l10n.landingPageTakePhotoButtonText),
      onPressed: () => Navigator.of(context).push(
        PhotoboothPage.route(),
      ),
    );
  }
}

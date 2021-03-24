import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';

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
              style: theme.textTheme.headline4,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.landingPageSubheading,
              style: theme.textTheme.headline6,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: Text(l10n.landingPageTakePhotoButtonText),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

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

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          key: const Key('landingPage_background'),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.landingPageHeading,
                  key: const Key('landingPage_heading_text'),
                  style: theme.textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.landingPageSubheading,
                  key: const Key('landingPage_subheading_text'),
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const TakePhotoButton(),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: BlackFooter(),
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

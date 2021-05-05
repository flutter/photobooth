import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingBackground extends StatelessWidget {
  const LandingBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

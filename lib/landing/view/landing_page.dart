import 'package:flutter/material.dart';
import 'package:io_photobooth/footer/footer.dart';
import 'package:io_photobooth/landing/landing.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PhotoboothColors.white,
      body: LandingView(),
    );
  }
}

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageView(
      background: LandingBackground(),
      body: LandingBody(),
      footer: BlackFooter(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:io_photobooth/external_links/external_links.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class IconLink extends StatelessWidget {
  const IconLink({
    Key? key,
    required this.icon,
    required this.link,
  }) : super(key: key);

  final Widget icon;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: () => openLink(link),
      child: SizedBox(height: 30, width: 30, child: icon),
    );
  }
}

class FlutterIconLink extends StatelessWidget {
  const FlutterIconLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Image.asset('assets/icons/flutter_icon.png'),
      link: flutterDevExternalLink,
    );
  }
}

class FirebaseIconLink extends StatelessWidget {
  const FirebaseIconLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconLink(
      icon: Image.asset('assets/icons/firebase_icon.png'),
      link: firebaseExternalLink,
    );
  }
}

class MadeWithIconLinks extends StatelessWidget {
  const MadeWithIconLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        FlutterIconLink(),
        SizedBox(width: 8),
        FirebaseIconLink(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class PermissionsBackground extends StatelessWidget {
  const PermissionsBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: (_) => Image.asset(
        'assets/backgrounds/permissions_background_mobile.jpg',
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
      ),
      desktop: (_) => Image.asset(
        'assets/backgrounds/permissions_background_desktop.jpg',
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
      ),
    );
  }
}

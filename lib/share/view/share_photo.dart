import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class SharePhoto extends StatelessWidget {
  const SharePhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      desktop: (_) => Image.asset(
        'assets/images/photo_placeholder_desktop.jpeg',
        filterQuality: FilterQuality.high,
      ),
      mobile: (_) => Image.asset(
        'assets/images/photo_placeholder_mobile.jpeg',
        filterQuality: FilterQuality.high,
        height: 300,
      ),
    );
  }
}

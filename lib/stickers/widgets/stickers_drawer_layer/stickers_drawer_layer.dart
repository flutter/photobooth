import 'package:flutter/material.dart';
import 'package:io_photobooth/stickers/stickers.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class StickersDrawerLayer extends StatelessWidget {
  const StickersDrawerLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformBuilder(
      mobile: const SizedBox(),
      desktop: const DesktopStickersDrawerLayer(),
    );
  }
}

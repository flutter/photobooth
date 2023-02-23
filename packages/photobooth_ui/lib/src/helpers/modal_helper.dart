import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

/// Show a modal as bottom sheet when mobile or portrait. Else displays a dialog
Future<T?> showAppModal<T>({
  required BuildContext context,
  required Widget portraitChild,
  required Widget landscapeChild,
  PlatformHelper? platformHelper,
}) {
  final isMobile = (platformHelper ?? PlatformHelper()).isMobile;
  final orientation = MediaQuery.of(context).orientation;

  if (isMobile || orientation == Orientation.portrait) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PhotoboothColors.transparent,
      builder: (_) => portraitChild,
    );
  } else {
    return showAppDialog(
      context: context,
      child: landscapeChild,
    );
  }
}

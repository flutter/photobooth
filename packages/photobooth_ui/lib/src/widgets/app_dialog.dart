import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// Displays a dialog above the current contents of the app.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) =>
    showDialog<T>(
      context: context,
      barrierColor: PhotoboothColors.charcoal,
      barrierDismissible: barrierDismissible,
      builder: (context) => _AppDialog(child: child),
    );

class _AppDialog extends StatelessWidget {
  const _AppDialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 900,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PhotoboothColors.whiteBackground,
              PhotoboothColors.white,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

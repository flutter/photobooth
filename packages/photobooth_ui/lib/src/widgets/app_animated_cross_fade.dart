import 'package:flutter/material.dart';

/// {@template app_animated_cross_fade}
/// Abstraction of AnimatedCrossFade to override the layout centering
/// the widgets inside
/// {@endtemplate}
class AppAnimatedCrossFade extends StatelessWidget {
  /// {@macro app_animated_cross_fade}

  const AppAnimatedCrossFade({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
  }) : super(key: key);

  /// First [Widget] to display
  final Widget firstChild;

  /// Second [Widget] to display
  final Widget secondChild;

  /// Specifies when to display [firstChild] or [secondChild]
  final CrossFadeState crossFadeState;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: crossFadeState,
      duration: const Duration(seconds: 1),
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              key: bottomChildKey,
              child: bottomChild,
            ),
            Align(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}

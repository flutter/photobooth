import 'package:flutter/material.dart';

/// {@template app_page_view}
/// A widget that constructs a page view consisting of a [background]
/// [body], [footer] pinned to the bottom of the page and an optional
/// list of overlay widgets displayed on top of the [body].
/// {@endtemplate}
class AppPageView extends StatelessWidget {
  /// {@macro app_page_view}
  const AppPageView({
    required this.body,
    required this.footer,
    this.background = const SizedBox(),
    this.overlays = const <Widget>[],
    super.key,
  });

  /// A body of the [AppPageView]
  final Widget body;

  /// Sticky footer displayed at the bottom of the [AppPageView]
  final Widget footer;

  /// An optional background of the [AppPageView]
  final Widget background;

  /// An optional list of overlays displayed on top of the [body]
  final List<Widget> overlays;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        background,
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: body),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 200,
                child: footer,
              ),
            ),
          ],
        ),
        ...overlays,
      ],
    );
  }
}

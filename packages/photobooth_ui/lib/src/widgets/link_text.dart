import 'package:flutter/material.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

/// {@template link_text}
/// Displays a [text] and navigates to the [link] upon click
/// {@endtemplate}
class LinkText extends StatelessWidget {
  /// {@macro link_text}
  const LinkText({
    Key? key,
    required this.text,
    required this.link,
  }) : super(key: key);

  /// Text to display
  final String text;

  /// Link to navigate
  final String link;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: () => openLink(link),
      child: Text(text),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Opens the given [url] in a new tab of the host browser
Future<void> openLink(String url, {VoidCallback? onError}) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else if (onError != null) {
    onError();
  }
}

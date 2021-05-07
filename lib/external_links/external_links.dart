import 'package:photobooth_ui/photobooth_ui.dart';

const googleIOExternalLink = 'https://events.google.com/io/';
const flutterDevExternalLink = 'https://flutter.dev';
const firebaseExternalLink = 'https://firebase.google.com';
const photoboothEmail = 'mailto:flutter-photo-booth@google.com';

Future<void> launchGoogleIOLink() => openLink(googleIOExternalLink);
Future<void> launchFlutterDevLink() => openLink(flutterDevExternalLink);
Future<void> launchFirebaseLink() => openLink(firebaseExternalLink);
Future<void> launchPhotoboothEmail() => openLink(photoboothEmail);

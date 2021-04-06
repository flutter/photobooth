import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:io_photobooth/decoration/decoration.dart';
import 'package:io_photobooth/preview/preview.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

class DecorationPage extends StatefulWidget {
  const DecorationPage({Key? key, required this.image}) : super(key: key);

  final ImageData image;

  static Route route({required ImageData image}) {
    return MaterialPageRoute(builder: (_) => DecorationPage(image: image));
  }

  @override
  _DecorationPageState createState() => _DecorationPageState();
}

class _DecorationPageState extends State<DecorationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PreviewImage(data: widget.image.data),
          GoToPreviewButton(image: widget.image),
          const _BackButton(),
          const StickersFrame(),
        ],
      ),
    );
  }
}

class GoToPreviewButton extends StatelessWidget {
  const GoToPreviewButton({
    Key? key,
    required this.image,
  }) : super(key: key);

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () =>
              Navigator.of(context).push(PreviewPage.route(image: image)),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 15,
        ),
        child: IconButton(
          key: const Key('decorationPage_backButton_iconButton'),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

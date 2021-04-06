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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: GoToPreviewButton(image: widget.image),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 15,
                top: 15,
              ),
              child: PhotoboothBackButton(),
            ),
          ),
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
    return FloatingActionButton(
      child: const Icon(Icons.arrow_forward),
      onPressed: () =>
          Navigator.of(context).push(PreviewPage.route(image: image)),
    );
  }
}

class PhotoboothBackButton extends StatelessWidget {
  const PhotoboothBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.refresh),
    );
  }
}

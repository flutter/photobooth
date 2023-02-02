import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class StickersLayer extends StatelessWidget {
  const StickersLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            for (final sticker in state.stickers)
              Builder(
                builder: (context) {
                  final widthFactor =
                      constraints.maxWidth / sticker.constraint.width;
                  final heightFactor =
                      constraints.maxHeight / sticker.constraint.height;
                  return Positioned(
                    key: Key(
                      '''stickersLayer_${sticker.asset.name}_${sticker.id}_positioned''',
                    ),
                    top: sticker.position.dy * heightFactor,
                    left: sticker.position.dx * widthFactor,
                    child: Transform.rotate(
                      angle: sticker.angle,
                      child: Image.asset(
                        sticker.asset.path,
                        fit: BoxFit.fill,
                        height: sticker.size.height * heightFactor,
                        width: sticker.size.width * widthFactor,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

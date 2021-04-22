import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';

class CharactersLayer extends StatelessWidget {
  const CharactersLayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PhotoboothBloc>().state;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            for (final character in state.characters)
              Builder(
                builder: (context) {
                  final widthFactor =
                      constraints.maxWidth / character.constraint.width;
                  final heightFactor =
                      constraints.maxHeight / character.constraint.height;
                  return Positioned(
                    key: Key(
                      'charactersLayer_${character.asset.name}_positioned',
                    ),
                    top: character.position.dy * heightFactor,
                    left: character.position.dx * widthFactor,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(character.scale)
                        ..rotateZ(character.angle),
                      child: Image.memory(
                        character.asset.bytes,
                        height: character.size.height * heightFactor,
                        width: character.size.width * widthFactor,
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

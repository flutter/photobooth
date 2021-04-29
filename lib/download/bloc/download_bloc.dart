import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image_compositor/image_compositor.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({
    required PhotosRepository photosRepository,
    required this.imageId,
    required this.image,
    required this.assets,
  })  : _photosRepository = photosRepository,
        super(const DownloadState.initial());

  final PhotosRepository _photosRepository;
  final String imageId;
  final CameraImage image;
  final List<PhotoAsset> assets;

  @override
  Stream<Transition<DownloadEvent, DownloadState>> transformEvents(
    Stream<DownloadEvent> events,
    TransitionFunction<DownloadEvent, DownloadState> transitionFn,
  ) {
    return events.switchMap(transitionFn);
  }

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    if (event is DownloadTapped) {
      yield* _mapDownloadTappedToState(state, event);
    }
  }

  Stream<DownloadState> _mapDownloadTappedToState(
    DownloadState state,
    DownloadTapped event,
  ) async* {
    if (state.status == DownloadStatus.loading) return;
    yield const DownloadState.loading();
    try {
      final composite = await _photosRepository.composite(
        aspectRatio: image.aspectRatio(),
        data: image.data,
        width: image.width,
        height: image.height,
        layers: [
          ...assets.map(
            (l) => CompositeLayer(
              angle: l.angle,
              assetPath: 'assets/${l.asset.path}',
              constraints: Vector2D(l.constraint.width, l.constraint.height),
              position: Vector2D(l.position.dx, l.position.dy),
              scale: l.scale,
              size: Vector2D(l.size.width, l.size.height),
            ),
          )
        ],
      );
      final file = XFile.fromData(
        Uint8List.fromList(composite),
        mimeType: 'image/jpeg',
        name: '$imageId.jpg',
      );
      yield DownloadState.success(file: file);
    } catch (error, stackTrace) {
      yield const DownloadState.error();
      addError(error, stackTrace);
    }
  }
}

extension on CameraImage {
  double aspectRatio() => width > height ? 4 / 3 : 3 / 4;
}

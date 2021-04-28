part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();
}

class DownloadTapped extends DownloadEvent {
  const DownloadTapped({
    required this.image,
    required this.assets,
  });

  final CameraImage image;
  final List<PhotoAsset> assets;

  @override
  List<Object> get props => [image, assets];
}

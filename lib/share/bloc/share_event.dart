part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();
}

class ShareOnTwitterTapped extends ShareEvent {
  ShareOnTwitterTapped({
    required this.image,
    required this.imageId,
    required this.assets,
    required this.shareText,
  });

  final CameraImage image;
  final String imageId;
  final List<PhotoAsset> assets;
  final String shareText;

  @override
  List<Object> get props => [image, imageId, assets, shareText];
}

class ShareOnFacebookTapped extends ShareEvent {
  ShareOnFacebookTapped({
    required this.image,
    required this.imageId,
    required this.assets,
    required this.shareText,
  });

  final CameraImage image;
  final String imageId;
  final List<PhotoAsset> assets;
  final String shareText;

  @override
  List<Object> get props => [image, imageId, assets, shareText];
}

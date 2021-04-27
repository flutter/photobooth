part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();
}

class ShareOnTwitter extends ShareEvent {
  ShareOnTwitter({
    required this.image,
    required this.imageName,
    required this.assets,
    required this.shareText,
  });

  final CameraImage image;
  final String imageName;
  final List<PhotoAsset> assets;
  final String shareText;

  @override
  List<Object> get props => [image, imageName, assets, shareText];
}

class ShareOnFacebook extends ShareEvent {
  ShareOnFacebook({
    required this.image,
    required this.imageName,
    required this.assets,
    required this.shareText,
  });

  final CameraImage image;
  final String imageName;
  final List<PhotoAsset> assets;
  final String shareText;

  @override
  List<Object> get props => [image, imageName, assets, shareText];
}

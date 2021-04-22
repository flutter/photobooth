part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareOnTwitter extends ShareEvent {
  ShareOnTwitter({required this.image, required this.assets});

  final CameraImage image;
  final List<PhotoAsset> assets;
}

class ShareOnFacebook extends ShareEvent {
  ShareOnFacebook({required this.image, required this.assets});

  final CameraImage image;
  final List<PhotoAsset> assets;
}

part of 'share_bloc.dart';

abstract class ShareEvent extends Equatable {
  const ShareEvent();

  @override
  List<Object> get props => [];
}

class ShareViewLoaded extends ShareEvent {
  const ShareViewLoaded();
}

class ShareDownloadTapped extends ShareEvent {
  const ShareDownloadTapped();
}

abstract class ShareTapped extends ShareEvent {
  const ShareTapped({required this.shareText});

  final String shareText;

  @override
  List<Object> get props => [shareText];
}

class ShareOnTwitterTapped extends ShareTapped {
  const ShareOnTwitterTapped({required String shareText})
      : super(shareText: shareText);
}

class ShareOnFacebookTapped extends ShareTapped {
  const ShareOnFacebookTapped({required String shareText})
      : super(shareText: shareText);
}

class _ShareCompositeSucceeded extends ShareEvent {
  const _ShareCompositeSucceeded({required this.bytes});
  final Uint8List bytes;
}

class _ShareCompositeFailed extends ShareEvent {
  const _ShareCompositeFailed();
}

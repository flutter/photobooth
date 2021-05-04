part of 'share_bloc.dart';

abstract class ShareState extends Equatable {
  const ShareState();

  @override
  List<Object> get props => [];
}

class ShareInitial extends ShareState {
  const ShareInitial();
}

class ShareCompositeInProgress extends ShareState {
  const ShareCompositeInProgress();
}

class ShareCompositeInProgressAndDownloadRequested
    extends ShareCompositeInProgress {
  const ShareCompositeInProgressAndDownloadRequested();
}

class ShareCompositeInProgressAndUploadRequested
    extends ShareCompositeInProgress {
  const ShareCompositeInProgressAndUploadRequested();
}

class ShareCompositeFailure extends ShareState {
  const ShareCompositeFailure();
}

class ShareCompositeSuccess extends ShareState {
  const ShareCompositeSuccess({required this.file, required this.bytes});

  final XFile file;
  final Uint8List bytes;

  @override
  List<Object> get props => [file, bytes];
}

class ShareCompositeSuccessAndDownloadRequested extends ShareCompositeSuccess {
  const ShareCompositeSuccessAndDownloadRequested({
    required XFile file,
    required Uint8List bytes,
  }) : super(file: file, bytes: bytes);
}

class ShareUploadInProgress extends ShareCompositeSuccess {
  const ShareUploadInProgress({
    required XFile file,
    required Uint8List bytes,
  }) : super(file: file, bytes: bytes);
}

class ShareUploadFailure extends ShareCompositeSuccess {
  const ShareUploadFailure({
    required XFile file,
    required Uint8List bytes,
  }) : super(file: file, bytes: bytes);
}

abstract class ShareUploadSuccess extends ShareCompositeSuccess {
  const ShareUploadSuccess({
    required XFile file,
    required Uint8List bytes,
    required this.twitterShareUrl,
    required this.facebookShareUrl,
  }) : super(file: file, bytes: bytes);

  final String twitterShareUrl;
  final String facebookShareUrl;

  @override
  List<Object> get props => [file, twitterShareUrl, facebookShareUrl];
}

class ShareOnTwitterSuccess extends ShareUploadSuccess {
  const ShareOnTwitterSuccess({
    required XFile file,
    required Uint8List bytes,
    required String twitterShareUrl,
    required String facebookShareUrl,
  }) : super(
          file: file,
          bytes: bytes,
          twitterShareUrl: twitterShareUrl,
          facebookShareUrl: facebookShareUrl,
        );
}

class ShareOnFacebookSuccess extends ShareUploadSuccess {
  const ShareOnFacebookSuccess({
    required XFile file,
    required Uint8List bytes,
    required String twitterShareUrl,
    required String facebookShareUrl,
  }) : super(
          file: file,
          bytes: bytes,
          twitterShareUrl: twitterShareUrl,
          facebookShareUrl: facebookShareUrl,
        );
}

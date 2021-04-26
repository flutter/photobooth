/// {@template share_photo_repository}
/// Repository that generates social media links to share a photo
/// {@endtemplate}
class SharePhotoRepository {
  /// {@macro share_photo_repository}
  const SharePhotoRepository({
    required String shareUrl,
    required bool isSharingEnabled,
  })  : _shareUrl = shareUrl,
        _isSharingEnabled = isSharingEnabled;

  final String _shareUrl;

  /// Feature flag that defines whether the sharing functionality is enabled.
  bool get isSharingEnabled => _isSharingEnabled;
  final bool _isSharingEnabled;

  /// Given a [photoName], it returns its Twitter share URL
  String getShareOnTwitterUrl(String photoName) {
    return 'https://twitter.com/intent/tweet?url=${_getSharePhotoUrl(photoName)}';
  }

  /// Given a [photoName], it returns its Facebook share URL
  String getShareOnFacebookUrl(String photoName) {
    return 'https://www.facebook.com/sharer.php?u=${_getSharePhotoUrl(photoName)}';
  }

  String _getSharePhotoUrl(String photoName) => '$_shareUrl/$photoName';
}

part of 'share_bloc.dart';

enum ShareStatus { initial, loading, success, error }

class ShareState extends Equatable {
  const ShareState._({
    required this.status,
    this.shareUrl = '',
  });

  const ShareState.initial() : this._(status: ShareStatus.initial);

  const ShareState.loading() : this._(status: ShareStatus.loading);

  const ShareState.success({required String shareUrl})
      : this._(
          status: ShareStatus.success,
          shareUrl: shareUrl,
        );

  const ShareState.error() : this._(status: ShareStatus.error);

  final ShareStatus status;

  final String shareUrl;

  @override
  List<Object> get props => [status];
}

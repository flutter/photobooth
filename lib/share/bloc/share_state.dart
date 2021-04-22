part of 'share_bloc.dart';

enum ShareStatus { initial, loading, success, error }

class ShareState extends Equatable {
  const ShareState._({required this.status});

  const ShareState.initial() : this._(status: ShareStatus.initial);

  const ShareState.loading() : this._(status: ShareStatus.loading);

  const ShareState.success() : this._(status: ShareStatus.success);

  const ShareState.error() : this._(status: ShareStatus.error);

  final ShareStatus status;

  @override
  List<Object> get props => [status];
}

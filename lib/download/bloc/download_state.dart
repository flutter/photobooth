part of 'download_bloc.dart';

enum DownloadStatus { initial, loading, success, error }

class DownloadState extends Equatable {
  const DownloadState._({
    this.status = DownloadStatus.initial,
    this.image,
  });

  const DownloadState.initial() : this._(status: DownloadStatus.initial);

  const DownloadState.loading() : this._(status: DownloadStatus.loading);

  const DownloadState.success({required Uint8List image})
      : this._(
          status: DownloadStatus.success,
          image: image,
        );

  const DownloadState.error() : this._(status: DownloadStatus.error);

  final DownloadStatus status;
  final Uint8List? image;

  @override
  List<Object?> get props => [status, image];
}
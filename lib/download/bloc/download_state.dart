part of 'download_bloc.dart';

enum DownloadStatus { initial, loading, success, error }

class DownloadState extends Equatable {
  const DownloadState._({
    this.status = DownloadStatus.initial,
    this.file,
  });

  const DownloadState.initial() : this._(status: DownloadStatus.initial);

  const DownloadState.loading() : this._(status: DownloadStatus.loading);

  const DownloadState.success({required XFile file})
      : this._(
          status: DownloadStatus.success,
          file: file,
        );

  const DownloadState.error() : this._(status: DownloadStatus.error);

  final DownloadStatus status;
  final XFile? file;

  @override
  List<Object?> get props => [status, file];
}

part of 'download_bloc.dart';

abstract class DownloadEvent extends Equatable {
  const DownloadEvent();

  @override
  List<Object> get props => [];
}

class DownloadTapped extends DownloadEvent {
  const DownloadTapped();
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/download/bloc/download_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:photos_repository/photos_repository.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadBloc(
        photosRepository: context.read<PhotosRepository>(),
      ),
      child: const DownloadButtonView(),
    );
  }
}

class DownloadButtonView extends StatelessWidget {
  const DownloadButtonView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select(
      (DownloadBloc bloc) => bloc.state.status == DownloadStatus.loading,
    );
    return BlocListener<DownloadBloc, DownloadState>(
      listener: (context, state) async {
        if (state.status == DownloadStatus.success) {
          await state.file?.saveTo('');
        }
      },
      child: OutlinedButton(
        key: const Key('downloadButton_download_outlinedButton'),
        onPressed: () {
          final state = context.read<PhotoboothBloc>().state;
          final image = state.image;
          if (image != null)
            context
                .read<DownloadBloc>()
                .add(DownloadTapped(image: image, assets: state.assets));
        },
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(l10n.sharePageDownloadButtonText),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/share/share.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select(
      (ShareBloc bloc) =>
          bloc.state is ShareCompositeInProgressAndDownloadRequested,
    );

    void _onDownloadPressed() {
      final bloc = context.read<ShareBloc>();
      final state = bloc.state;
      if (state is ShareCompositeSuccess) {
        state.file.saveTo('');
        return;
      }
      bloc.add(const ShareDownloadTapped());
    }

    return BlocListener<ShareBloc, ShareState>(
      listener: (context, state) {
        if (state is ShareCompositeSuccessAndDownloadRequested) {
          state.file.saveTo('');
        }
      },
      child: OutlinedButton(
        key: const Key('downloadButton_download_outlinedButton'),
        onPressed: !isLoading ? _onDownloadPressed : null,
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(l10n.sharePageDownloadButtonText),
      ),
    );
  }
}

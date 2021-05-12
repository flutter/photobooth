import 'dart:typed_data';

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:io_photobooth/photobooth/photobooth.dart';
import 'package:io_photobooth/share/share.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:provider/provider.dart';

class ShareButton extends StatelessWidget {
  ShareButton({
    Key? key,
    required this.image,
    PlatformHelper? platformHelper,
  })  : platformHelper = platformHelper ?? PlatformHelper(),
        super(key: key);

  /// Composited image
  final Uint8List image;

  /// Optional [PlatformHelper] instance.
  final PlatformHelper platformHelper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('sharePage_share_elevatedButton'),
      onPressed: () {
        trackEvent(
          category: 'button',
          action: 'click-share-photo',
          label: 'share-photo',
        );
        showAppModal(
          context: context,
          platformHelper: platformHelper,
          landscapeChild: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<PhotoboothBloc>()),
              BlocProvider.value(value: context.read<ShareBloc>()),
            ],
            child: ShareDialog(image: image),
          ),
          portraitChild: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<PhotoboothBloc>()),
              BlocProvider.value(value: context.read<ShareBloc>()),
            ],
            child: ShareBottomSheet(image: image),
          ),
        );
      },
      child: Text(l10n.sharePageShareButtonText),
    );
  }
}

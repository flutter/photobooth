import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _backgroundColor = Color(0xFFF1F3F4);
const _textColor = Color(0xFF80858A);

class ShareCopyableLink extends StatefulWidget {
  const ShareCopyableLink({
    required this.link,
    this.suspendDuration = const Duration(seconds: 5),
    super.key,
  });

  /// The link that will be stored in the [Clipboard]
  /// when [_CopyButton] is tapped.
  final String link;

  /// The duration for which the [_CopiedButton] is visible
  /// after tapping on the [_CopyButton]. Defaults to 5 seconds.
  final Duration suspendDuration;

  @override
  ShareCopyableLinkState createState() => ShareCopyableLinkState();
}

@visibleForTesting
class ShareCopyableLinkState extends State<ShareCopyableLink> {
  @visibleForTesting
  Timer? timer;

  @visibleForTesting
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 24),
          const Icon(Icons.link, color: _textColor),
          const SizedBox(width: 16),
          Flexible(
            child: SelectableText(
              widget.link,
              style: theme.textTheme.labelLarge?.copyWith(
                color: _textColor,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.all(6),
            child: copied
                ? _CopiedButton(
                    key: const Key('shareCopyableLink_copiedButton'),
                    onPressed: _resetCopied,
                  )
                : _CopyButton(
                    key: const Key('shareCopyableLink_copyButton'),
                    onPressed: _copy,
                  ),
          ),
        ],
      ),
    );
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.link));

    setState(() {
      copied = true;
    });

    timer?.cancel();
    timer = Timer(
      const Duration(seconds: 5),
      _resetCopied,
    );
  }

  void _resetCopied() {
    if (mounted) {
      setState(() => copied = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

final _copyButtonsMinimumSize = MaterialStateProperty.all(const Size(120, 40));
final _copyButtonsShape = MaterialStateProperty.all(
  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: _copyButtonsMinimumSize,
        backgroundColor: MaterialStateProperty.all(PhotoboothColors.blue),
        shape: _copyButtonsShape,
      ),
      onPressed: onPressed,
      child: Text(l10n.sharePageCopyLinkButton),
    );
  }
}

class _CopiedButton extends StatelessWidget {
  const _CopiedButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: _copyButtonsMinimumSize,
        backgroundColor: MaterialStateProperty.all(PhotoboothColors.green),
        shape: _copyButtonsShape,
      ),
      onPressed: onPressed,
      child: Text(l10n.sharePageLinkedCopiedButton),
    );
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_photobooth/l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _shutterCountdownDuration = Duration(seconds: 3);

AudioPlayer _getAudioPlayer() => AudioPlayer();

class ShutterButton extends StatefulWidget {
  const ShutterButton({
    required this.onCountdownComplete,
    super.key,
    ValueGetter<AudioPlayer>? audioPlayer,
  }) : _audioPlayer = audioPlayer ?? _getAudioPlayer;

  final VoidCallback onCountdownComplete;
  final ValueGetter<AudioPlayer> _audioPlayer;

  @override
  State<ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AudioPlayer audioPlayer;

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onCountdownComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = widget._audioPlayer()..setAsset('assets/audio/camera.mp3');
    controller = AnimationController(
      vsync: this,
      duration: _shutterCountdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);
    unawaited(audioPlayer.play());
    audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.ready) {
        audioPlayer.pause();
      }
    });
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _onShutterPressed() async {
    await audioPlayer.seek(null);
    unawaited(audioPlayer.play());
    unawaited(controller.reverse(from: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return controller.isAnimating
            ? CountdownTimer(controller: controller)
            : CameraButton(onPressed: _onShutterPressed);
      },
    );
  }
}

class CountdownTimer extends StatelessWidget {
  const CountdownTimer({required this.controller, super.key});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final seconds =
        (_shutterCountdownDuration.inSeconds * controller.value).ceil();
    final theme = Theme.of(context);
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Align(
            child: Text(
              '$seconds',
              style: theme.textTheme.displayLarge?.copyWith(
                color: PhotoboothColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TimerPainter(animation: controller, countdown: seconds),
            ),
          )
        ],
      ),
    );
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      focusable: true,
      button: true,
      label: l10n.shutterButtonLabelText,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: const CircleBorder(),
        color: PhotoboothColors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            'assets/icons/camera_button_icon.png',
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  const TimerPainter({
    required this.animation,
    required this.countdown,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final int countdown;
  @visibleForTesting
  Color calculateColor() {
    if (countdown == 3) return PhotoboothColors.blue;
    if (countdown == 2) return PhotoboothColors.orange;
    return PhotoboothColors.green;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progressColor = calculateColor();
    final progress = ((1 - animation.value) * (2 * math.pi) * 3) -
        ((3 - countdown) * (2 * math.pi));

    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = PhotoboothColors.white;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => false;
}

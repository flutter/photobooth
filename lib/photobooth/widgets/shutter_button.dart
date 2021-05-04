import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

const _shutterCountdownDuration = Duration(seconds: 3);
const _countdownInterval = Duration(seconds: 1);

AudioPlayer _getAudioPlayer() => AudioPlayer();

class ShutterButton extends StatefulWidget {
  const ShutterButton({
    Key? key,
    required this.onCountdownComplete,
    ValueGetter<AudioPlayer>? audioPlayer,
  })  : _audioPlayer = audioPlayer ?? _getAudioPlayer,
        super(key: key);

  final VoidCallback onCountdownComplete;
  final ValueGetter<AudioPlayer> _audioPlayer;

  @override
  _ShutterButtonState createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton>
    with TickerProviderStateMixin {
  final countdownAudioSource = AudioSource.uri(
    Uri.parse('asset:///assets/audio/countdown.mp3'),
  );
  final captureAudioSource = AudioSource.uri(
    Uri.parse('asset:///assets/audio/capture.mp3'),
  );
  late final AnimationController controller;
  late final AudioPlayer countdownPlayer;
  late final AudioPlayer capturePlayer;

  void _onAnimationStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.dismissed) {
      _playShutterSound();
      widget.onCountdownComplete();
    }
  }

  void _playCountdownSequence() async {
    void _playCountdownSound() {
      if (countdownPlayer.position != Duration.zero) countdownPlayer.setClip();
      countdownPlayer.play();
    }

    for (var i = 0; i < _shutterCountdownDuration.inSeconds; i++) {
      _playCountdownSound();
      await Future.delayed(_countdownInterval);
    }
  }

  void _playShutterSound() {
    if (capturePlayer.position != Duration.zero) capturePlayer.setClip();
    capturePlayer.play();
  }

  @override
  void initState() {
    super.initState();
    countdownPlayer = widget._audioPlayer()
      ..setAudioSource(countdownAudioSource)
      ..load();
    capturePlayer = widget._audioPlayer()
      ..setAudioSource(captureAudioSource)
      ..load();

    controller = AnimationController(
      vsync: this,
      duration: _shutterCountdownDuration,
    )..addStatusListener(_onAnimationStatusChanged);
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    countdownPlayer.dispose();
    capturePlayer.dispose();
    super.dispose();
  }

  void _onShutterPressed() {
    controller.reverse(from: 1);
    _playCountdownSequence();
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
  const CountdownTimer({Key? key, required this.controller}) : super(key: key);

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final seconds =
        (_shutterCountdownDuration.inSeconds * controller.value).ceil();
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '$seconds',
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w500,
                color: PhotoboothColors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: TimerPainter(
                animation: controller,
                countdown: seconds,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CameraButton extends StatelessWidget {
  const CameraButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      color: PhotoboothColors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/icons/camera_button_icon.png',
          height: 84,
          width: 84,
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

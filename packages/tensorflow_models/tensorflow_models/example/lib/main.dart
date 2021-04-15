import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;
import 'package:tensorflow_models/tensorflow_models.dart';

const List<int> kTransparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  posenet.PoseNet? _net;

  @override
  void initState() {
    super.initState();
    _initializePosenet();
  }

  void _initializePosenet() async {
    _net?.dispose();
    _net = await posenet.load();
    final pose = await _net!.estimateSinglePose(ImageData(
      data: Uint8ClampedList.fromList(kTransparentImage),
      width: 4,
      height: 4,
    ));
    print(pose.score);
    for (final keypoint in pose.keypoints) {
      print(keypoint.part);
      print(keypoint.score);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

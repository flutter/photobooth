import 'package:flutter/material.dart';
import 'package:tensorflow_models/posenet.dart' as posenet;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializePosenet();
  }

  void _initializePosenet() async {
    final net = await posenet.load();
    print(net);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

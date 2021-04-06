// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  const List<int> transparentImage = <int>[
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

  final data = Uint8List.fromList(transparentImage);

  group('PreviewImage', () {
    testWidgets('renders with height and width', (tester) async {
      await tester.pumpWidget(PreviewImage(
        data: data,
        height: 100,
        width: 100,
      ));
      expect(find.byType(PreviewImage), findsOneWidget);
    });
    testWidgets('renders without width as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data, height: 100));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders without height as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data, width: 100));
      expect(find.byType(PreviewImage), findsOneWidget);
    });

    testWidgets('renders without height/width as parameter', (tester) async {
      await tester.pumpWidget(PreviewImage(data: data));
      expect(find.byType(PreviewImage), findsOneWidget);
    });
  });
}

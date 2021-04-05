// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:photobooth_ui/photobooth_ui.dart';

void main() {
  final data = Uint8List.fromList([]);

  group('PreviewImage', () {
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

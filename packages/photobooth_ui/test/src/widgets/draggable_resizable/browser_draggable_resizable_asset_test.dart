@TestOn('browser')

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import '../../../helpers/constants.dart';

class MockImage extends Mock implements ui.Image {}

class MockAsset extends Mock implements Asset {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Asset asset;
  late ui.Image image;

  group(
    'BrowserDraggableResizableImage',
    () {
      setUp(() {
        image = MockImage();
        asset = MockAsset();

        when(() => image.width).thenReturn(200);

        when(() => image.height).thenReturn(200);
        when(() => asset.image).thenReturn(image);
        when(() => asset.bytes)
            .thenReturn(Uint8List.fromList(transparentImage));
      });

      testWidgets('renders', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
            ),
          ),
        );
        expect(find.byType(DraggableResizableAsset), findsOneWidget);
      });

      testWidgets(
          'renders DesktopDraggableResizableImage when in Platform'
          'is not mobile', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
            ),
          ),
        );
        expect(find.byType(DesktopDraggableResizableImage), findsOneWidget);
      });
    },
  );
}

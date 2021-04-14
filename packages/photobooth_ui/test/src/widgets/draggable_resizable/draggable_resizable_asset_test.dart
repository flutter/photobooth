@TestOn('!browser')
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:photobooth_ui/src/platform_helper/platform_helper.dart';

import '../../../helpers/constants.dart';

class MockImage extends Mock implements ui.Image {}

class MockAsset extends Mock implements Asset {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Asset asset;
  late ui.Image image;

  group(
    'DraggableResizableImage',
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
          'renders MobileDraggableResizableImage when in Platform is mobile',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
            ),
          ),
        );
        expect(find.byType(MobileDraggableResizableImage), findsOneWidget);
      });
    },
  );
}

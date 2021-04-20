@TestOn('!chrome')
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photobooth_ui/photobooth_ui.dart';
import 'package:platform_helper/platform_helper.dart';

import '../../../helpers/constants.dart';

class MockImage extends Mock implements ui.Image {}

class MockPlatformHelper extends Mock implements PlatformHelper {}

class MockAsset extends Mock implements Asset {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Asset asset;
  late ui.Image image;
  late PlatformHelper platformHelper;

  group(
    'DraggableResizableImage',
    () {
      setUp(() {
        image = MockImage();
        asset = MockAsset();
        platformHelper = MockPlatformHelper();

        when(() => image.width).thenReturn(200);
        when(() => image.height).thenReturn(200);
        when(() => asset.image).thenReturn(image);
        when(() => asset.bytes)
            .thenReturn(Uint8List.fromList(transparentImage));
        when(() => platformHelper.isMobile).thenReturn(true);
      });

      testWidgets('renders MobileDraggableResizableImage by (default)',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: DraggableResizableAsset(asset: asset)),
        );
        expect(find.byType(MobileDraggableResizableImage), findsOneWidget);
      });

      testWidgets(
          'renders MobileDraggableResizableImage when Platform is mobile',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
            ),
          ),
        );
        expect(find.byType(MobileDraggableResizableImage), findsOneWidget);
      });

      testWidgets(
          'renders DesktopDraggableResizableImage when Platform is not mobile',
          (tester) async {
        when(() => platformHelper.isMobile).thenReturn(false);
        await tester.pumpWidget(
          MaterialApp(
            home: DraggableResizableAsset(
              asset: asset,
              platformHelper: platformHelper,
            ),
          ),
        );
        expect(find.byType(DesktopDraggableResizableImage), findsOneWidget);
      });
    },
  );
}

// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/assets.g.dart';
import 'package:io_photobooth/stickers/stickers.dart';

import '../../helpers/helpers.dart';

void main() {
  const googleTabAssetPath = 'assets/icons/google_icon.png';
  const hatsTabAssetPath = 'assets/icons/hats_icon.png';
  const eyewearTabAssetPath = 'assets/icons/eyewear_icon.png';
  const foodTabAssetPath = 'assets/icons/food_icon.png';
  const shapesTabAssetPath = 'assets/icons/shapes_icon.png';

  group('StickersTabs', () {
    testWidgets('onTabChanged is called with correct index', (tester) async {
      var onTabChangedCalls = <int>[];
      await tester.pumpApp(
        Scaffold(
          body: StickersTabs(
            onStickerSelected: (_) {},
            onTabChanged: onTabChangedCalls.add,
          ),
        ),
      );
      await tester.tap(find.byKey(Key('stickersTabs_hatsTab')));
      await tester.pump();
      expect(onTabChangedCalls, equals([1]));
    });

    group('TabBar', () {
      group('google', () {
        testWidgets('renders as first tab', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBar>(find.byType(TabBar));
          expect(tabBar.tabs[0].key, equals(Key('stickersTabs_googleTab')));
        });

        testWidgets('has correct correct asset path', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tab = tester.widget<StickersTab>(
            find.byKey(Key('stickersTabs_googleTab')),
          );
          expect(tab.assetPath, equals(googleTabAssetPath));
        });
      });

      group('hats', () {
        testWidgets('renders as second tab', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBar>(find.byType(TabBar));
          expect(tabBar.tabs[1].key, equals(Key('stickersTabs_hatsTab')));
        });

        testWidgets('has correct correct asset path', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tab = tester.widget<StickersTab>(
            find.byKey(Key('stickersTabs_hatsTab')),
          );
          expect(tab.assetPath, equals(hatsTabAssetPath));
        });
      });

      group('eyewear', () {
        testWidgets('renders as third tab', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBar>(find.byType(TabBar));
          expect(tabBar.tabs[2].key, equals(Key('stickersTabs_eyewearTab')));
        });

        testWidgets('has correct correct asset path', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tab = tester
              .widget<StickersTab>(find.byKey(Key('stickersTabs_eyewearTab')));
          expect(tab.assetPath, equals(eyewearTabAssetPath));
        });
      });

      group('food', () {
        testWidgets('renders as fourth tab', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBar>(find.byType(TabBar));
          expect(tabBar.tabs[3].key, equals(Key('stickersTabs_foodTab')));
        });

        testWidgets('has correct correct asset path', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tab = tester
              .widget<StickersTab>(find.byKey(Key('stickersTabs_foodTab')));
          expect(tab.assetPath, equals(foodTabAssetPath));
        });
      });

      group('shapes', () {
        testWidgets('renders as fifth tab', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBar>(find.byType(TabBar));
          expect(tabBar.tabs[4].key, equals(Key('stickersTabs_shapesTab')));
        });

        testWidgets('has correct correct asset path', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tab = tester
              .widget<StickersTab>(find.byKey(Key('stickersTabs_shapesTab')));
          expect(tab.assetPath, equals(shapesTabAssetPath));
        });
      });
    });

    group('TabBarView', () {
      group('google', () {
        testWidgets('renders as first tab bar view', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBarView>(find.byType(TabBarView));
          expect(
            tabBar.children[0].key,
            equals(Key('stickersTabs_googleTabBarView')),
          );
        });

        testWidgets('has correct stickers', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );

          final tabBarView = tester.widget<StickersTabBarView>(
              find.byKey(Key('stickersTabs_googleTabBarView')));
          expect(tabBarView.stickers, equals(Assets.googleProps));
        });
      });

      group('hats', () {
        testWidgets('renders as second tab bar view', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBarView>(find.byType(TabBarView));
          expect(
            tabBar.children[1].key,
            equals(Key('stickersTabs_hatsTabBarView')),
          );
        });

        testWidgets('has correct stickers', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );

          /// Swipe to the second page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );
          await tester.pump();
          await tester.pump(kThemeAnimationDuration);
          final tabBarView = tester.widget<StickersTabBarView>(
            find.byKey(Key('stickersTabs_hatsTabBarView')),
          );
          expect(tabBarView.stickers, equals(Assets.hatProps));
        });
      });

      group('eyewear', () {
        testWidgets('renders as third tab bar view', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBarView>(find.byType(TabBarView));
          expect(
            tabBar.children[2].key,
            equals(Key('stickersTabs_eyewearTabBarView')),
          );
        });

        testWidgets('has correct stickers', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );

          /// Swipe to the second page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );
          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the third page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );
          await tester.pump();
          await tester.pump(kThemeAnimationDuration);
          final tabBarView = tester.widget<StickersTabBarView>(
            find.byKey(Key('stickersTabs_eyewearTabBarView')),
          );
          expect(tabBarView.stickers, equals(Assets.eyewearProps));
        });
      });

      group('food', () {
        testWidgets('renders as fourth tab bar view', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBarView>(find.byType(TabBarView));
          expect(
            tabBar.children[3].key,
            equals(Key('stickersTabs_foodTabBarView')),
          );
        });

        testWidgets('has correct stickers', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );

          /// Swipe to the second page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the third page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the fourth page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          final tabBarView = tester.widget<StickersTabBarView>(
            find.byKey(Key('stickersTabs_foodTabBarView')),
          );
          expect(tabBarView.stickers, equals(Assets.foodProps));
        });
      });

      group('shapes', () {
        testWidgets('renders as fourth tab bar view', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );
          final tabBar = tester.widget<TabBarView>(find.byType(TabBarView));
          expect(
            tabBar.children[4].key,
            equals(Key('stickersTabs_shapesTabBarView')),
          );
        });

        testWidgets('has correct stickers', (tester) async {
          await tester.pumpApp(
            Scaffold(
              body: StickersTabs(
                onStickerSelected: (_) {},
                onTabChanged: (_) {},
              ),
            ),
          );

          /// Swipe to the second page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the third page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the fourth page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          /// Swipe to the fifth page.
          await tester.fling(
            find.byType(StickersTabs),
            const Offset(-200.0, 0.0),
            1000,
          );

          await tester.pump();
          await tester.pump(kThemeAnimationDuration);

          final tabBarView = tester.widget<StickersTabBarView>(
            find.byKey(Key('stickersTabs_shapesTabBarView')),
          );
          expect(tabBarView.stickers, equals(Assets.shapeProps));
        });
      });
    });
  });

  group('StickersTab', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: StickersTab(assetPath: googleTabAssetPath),
        ),
      );
      expect(find.byType(StickersTab), findsOneWidget);
    });

    testWidgets('renders tab widget', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: StickersTab(assetPath: googleTabAssetPath),
        ),
      );
      expect(find.byType(Tab), findsOneWidget);
    });

    testWidgets('renders image widget', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: StickersTab(assetPath: googleTabAssetPath),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });
  });
}

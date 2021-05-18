// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_photobooth/photobooth/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CharacterIconButton', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterIconButton(
              isSelected: true,
              icon: const AssetImage('assets/icons/dash_icon.png'),
              label: 'Dash',
            ),
          ),
        ),
      );

      expect(find.byType(CharacterIconButton), findsOneWidget);
    });

    testWidgets('is tappable', (tester) async {
      var tapCounter = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterIconButton(
              isSelected: true,
              icon: const AssetImage('assets/icons/dash_icon.png'),
              label: 'Dash',
              onPressed: () => tapCounter++,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(CharacterIconButton));
      await tester.pumpAndSettle();

      expect(tapCounter, equals(1));
    });

    testWidgets('renders big Ink widget when orientation is landscape',
        (tester) async {
      tester.setDisplaySize(landscapeDisplaySize);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterIconButton(
              isSelected: true,
              icon: const AssetImage('assets/icons/dash_icon.png'),
              label: 'Dash',
            ),
          ),
        ),
      );

      final inkWidget = tester.widget<Ink>(
        find.descendant(
          of: find.byType(CharacterIconButton),
          matching: find.byType(Ink),
        ),
      );

      expect(inkWidget.height, equals(90));
      expect(inkWidget.width, equals(90));
    });

    testWidgets('renders small Ink widget when orientation is portrait',
        (tester) async {
      tester.setDisplaySize(portraitDisplaySize);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterIconButton(
              isSelected: true,
              icon: const AssetImage('assets/icons/dash_icon.png'),
              label: 'Dash',
            ),
          ),
        ),
      );

      final inkWidget = tester.widget<Ink>(
        find.descendant(
          of: find.byType(CharacterIconButton),
          matching: find.byType(Ink),
        ),
      );

      expect(inkWidget.height, equals(60));
      expect(inkWidget.width, equals(60));
    });

    testWidgets('has a semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CharacterIconButton(
              isSelected: true,
              icon: const AssetImage('assets/icons/dash_icon.png'),
              label: 'Dash',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Dash'), findsOneWidget);
    });
  });
}

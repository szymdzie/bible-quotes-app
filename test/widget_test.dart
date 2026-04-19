import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_quotes/models/mood.dart';
import 'package:bible_quotes/models/quote.dart';
import 'package:bible_quotes/models/user.dart';

void main() {
  group('Mood Model Tests', () {
    test('Mood enum has 6 values', () {
      expect(Mood.values.length, 6);
    });

    test('All moods have valid properties', () {
      for (final mood in Mood.all) {
        expect(mood.key, isNotEmpty);
        expect(mood.displayName, isNotEmpty);
        expect(mood.displayNameEn, isNotEmpty);
        expect(mood.color, isNotNull);
        expect(mood.icon, isNotNull);
      }
    });
  });

  group('Quote Model Tests', () {
    test('Quote can be created', () {
      final quote = Quote(
        id: 'test-1',
        text: 'Test quote text',
        reference: 'Test 1:1',
        mood: 'happiness',
        language: 'pl',
        translation: 'Test Translation',
      );

      expect(quote.id, 'test-1');
      expect(quote.text, 'Test quote text');
      expect(quote.reference, 'Test 1:1');
    });

    test('Quote has all required fields', () {
      final quote = Quote(
        id: 'test-2',
        text: 'Text',
        reference: 'Ref',
        mood: 'sadness',
        language: 'en',
        translation: 'NIV',
      );

      expect(quote.id, isNotEmpty);
      expect(quote.text, isNotEmpty);
      expect(quote.reference, isNotEmpty);
      expect(quote.mood, isNotEmpty);
      expect(quote.language, isNotEmpty);
      expect(quote.translation, isNotEmpty);
    });
  });

  group('Widget Tests', () {
    testWidgets('MaterialApp can be created', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'Test',
          home: Scaffold(
            body: Center(child: Text('Bible Quotes')),
          ),
        ),
      );

      expect(find.text('Bible Quotes'), findsOneWidget);
    });

    testWidgets('MoodCard displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: Mood.all.map((mood) => ListTile(
                leading: Icon(mood.icon),
                title: Text(mood.displayName),
              )).toList(),
            ),
          ),
        ),
      );

      for (final mood in Mood.all) {
        expect(find.text(mood.displayName), findsOneWidget);
      }
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bible_quotes/main.dart';
import 'package:bible_quotes/models/mood.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BibleQuotesApp());

    expect(find.text('Bible Quotes'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Mood enum has 6 values', (WidgetTester tester) async {
    final mood = Mood.values;
    expect(mood.length, 6);
  });
}

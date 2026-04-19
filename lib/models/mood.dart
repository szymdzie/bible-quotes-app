import 'package:flutter/material.dart';

enum Mood {
  anger,
  loneliness,
  anxiety,
  sadness,
  happiness,
  gratitude;

  String get key {
    switch (this) {
      case Mood.anger:
        return 'anger';
      case Mood.loneliness:
        return 'loneliness';
      case Mood.anxiety:
        return 'anxiety';
      case Mood.sadness:
        return 'sadness';
      case Mood.happiness:
        return 'happiness';
      case Mood.gratitude:
        return 'gratitude';
    }
  }

  String get displayName {
    switch (this) {
      case Mood.anger:
        return 'Złość';
      case Mood.loneliness:
        return 'Samotność';
      case Mood.anxiety:
        return 'Niepokój';
      case Mood.sadness:
        return 'Smutek';
      case Mood.happiness:
        return 'Szczęście';
      case Mood.gratitude:
        return 'Wdzięczność';
    }
  }

  String get displayNameEn {
    switch (this) {
      case Mood.anger:
        return 'Anger';
      case Mood.loneliness:
        return 'Loneliness';
      case Mood.anxiety:
        return 'Anxiety';
      case Mood.sadness:
        return 'Sadness';
      case Mood.happiness:
        return 'Happiness';
      case Mood.gratitude:
        return 'Gratitude';
    }
  }

  Color get color {
    switch (this) {
      case Mood.anger:
        return const Color(0xFFE57373);
      case Mood.loneliness:
        return const Color(0xFF90A4AE);
      case Mood.anxiety:
        return const Color(0xFFFFB74D);
      case Mood.sadness:
        return const Color(0xFF64B5F6);
      case Mood.happiness:
        return const Color(0xFFFFF176);
      case Mood.gratitude:
        return const Color(0xFF81C784);
    }
  }

  IconData get icon {
    switch (this) {
      case Mood.anger:
        return Icons.sentiment_very_dissatisfied;
      case Mood.loneliness:
        return Icons.person_outline;
      case Mood.anxiety:
        return Icons.warning_amber;
      case Mood.sadness:
        return Icons.sentiment_dissatisfied;
      case Mood.happiness:
        return Icons.sentiment_satisfied;
      case Mood.gratitude:
        return Icons.favorite;
    }
  }

  static List<Mood> get all => [
    Mood.anger,
    Mood.loneliness,
    Mood.anxiety,
    Mood.sadness,
    Mood.happiness,
    Mood.gratitude,
  ];
}

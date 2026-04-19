import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String id;
  final String text;
  final String reference;
  final String mood;
  final String language;
  final String translation;
  final String? backgroundImage;
  final DateTime? createdAt;

  Quote({
    required this.id,
    required this.text,
    required this.reference,
    required this.mood,
    required this.language,
    required this.translation,
    this.backgroundImage,
    this.createdAt,
  });

  factory Quote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quote(
      id: doc.id,
      text: data['text'] ?? '',
      reference: data['reference'] ?? '',
      mood: data['mood'] ?? '',
      language: data['language'] ?? '',
      translation: data['translation'] ?? '',
      backgroundImage: data['backgroundImage'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'reference': reference,
      'mood': mood,
      'language': language,
      'translation': translation,
      'backgroundImage': backgroundImage,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}

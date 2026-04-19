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

  factory Quote.fromMap(Map<String, dynamic> data, String id) {
    return Quote(
      id: id,
      text: data['text'] ?? '',
      reference: data['reference'] ?? '',
      mood: data['mood'] ?? '',
      language: data['language'] ?? '',
      translation: data['translation'] ?? '',
      backgroundImage: data['backgroundImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'reference': reference,
      'mood': mood,
      'language': language,
      'translation': translation,
      'backgroundImage': backgroundImage,
    };
  }
}

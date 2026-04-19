class AppUser {
  final String uid;
  final String name;
  final String email;
  final String language;
  final DateTime createdAt;
  final DateTime? lastActive;
  final Map<String, dynamic> preferences;

  AppUser({
    required this.uid,
    required this.name,
    this.email = '',
    required this.language,
    required this.createdAt,
    this.lastActive,
    this.preferences = const {},
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      language: data['language'] ?? 'pl',
      createdAt: DateTime.now(),
      preferences: data['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'language': language,
      'preferences': preferences,
    };
  }
}

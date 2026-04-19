import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      language: data['language'] ?? 'pl',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      lastActive: data['lastActive']?.toDate(),
      preferences: data['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'language': language,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
      'preferences': preferences,
    };
  }
}

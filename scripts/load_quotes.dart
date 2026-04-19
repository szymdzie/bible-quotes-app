import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Skrypt do ładowania cytatów z plików JSON do Firestore
///
/// Użycie:
/// dart run scripts/load_quotes.dart
///
/// Wymagania:
/// - skonfigurowany Firebase Admin SDK
/// - pliki JSON w katalogu assets/data/

Future<void> main() async {
  await Firebase.initializeApp();
  
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  
  // Ładowanie polskich cytatów
  await loadQuotesFromFile(
    firestore: firestore,
    batch: batch,
    filePath: 'assets/data/quotes_pl.json',
  );
  
  // Ładowanie angielskich cytatów
  await loadQuotesFromFile(
    firestore: firestore,
    batch: batch,
    filePath: 'assets/data/quotes_en.json',
  );
  
  await batch.commit();
  print('Cytaty zostały załadowane do Firestore.');
}

Future<void> loadQuotesFromFile({
  required FirebaseFirestore firestore,
  required WriteBatch batch,
  required String filePath,
}) async {
  final file = File(filePath);
  if (!await file.exists()) {
    print('Plik $filePath nie istnieje, pominięto.');
    return;
  }
  
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString) as Map<String, dynamic>;
  final quotes = data['quotes'] as List<dynamic>;
  
  for (final quote in quotes) {
    final quoteData = quote as Map<String, dynamic>;
    final docRef = firestore.collection('quotes').doc(quoteData['id'] as String);
    batch.set(docRef, {
      'text': quoteData['text'],
      'reference': quoteData['reference'],
      'mood': quoteData['mood'],
      'language': quoteData['language'],
      'translation': quoteData['translation'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  print('Załadowano ${quotes.length} cytatów z $filePath');
}

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Random _random = Random();

  Future<Quote?> getRandomQuote(String mood, String language) async {
    try {
      final querySnapshot = await _firestore
          .collection('quotes')
          .where('mood', isEqualTo: mood)
          .where('language', isEqualTo: language)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return getRandomQuoteFallback(mood, language);
      }

      final randomIndex = _random.nextInt(querySnapshot.docs.length);
      return Quote.fromFirestore(querySnapshot.docs[randomIndex]);
    } catch (e) {
      return getRandomQuoteFallback(mood, language);
    }
  }

  Quote? getRandomQuoteFallback(String mood, String language) {
    final fallbackQuotes = _getFallbackQuotes();
    final moodQuotes = fallbackQuotes
        .where((q) => q.mood == mood && q.language == language)
        .toList();

    if (moodQuotes.isEmpty) {
      final genericQuotes = fallbackQuotes.where((q) => q.mood == mood).toList();
      if (genericQuotes.isEmpty) return null;
      return genericQuotes[_random.nextInt(genericQuotes.length)];
    }

    return moodQuotes[_random.nextInt(moodQuotes.length)];
  }

  List<Quote> _getFallbackQuotes() {
    return [
      Quote(
        id: '1',
        text: 'Gniewajcie się, a nie grzeszcie: niech nie zachodzi słońce nad gniewem waszym.',
        reference: 'Ef 4,26',
        mood: 'anger',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '2',
        text: 'O wszystkim zawiadamiajcie Boga w modlitwie i prośbie, z dziękczynieniem.',
        reference: 'Flp 4,6',
        mood: 'anxiety',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '3',
        text: 'Pan bliski jest strwojonym sercom i utrapionym w duchu zbawia.',
        reference: 'Ps 34,19',
        mood: 'sadness',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '4',
        text: 'Weselcie się zawsze w Panu; jeszcze raz powtarzam: weselcie się!',
        reference: 'Flp 4,4',
        mood: 'happiness',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '5',
        text: 'Dziękujcie Panu, bo jest dobry, bo trwa na wieki Jego łaska.',
        reference: 'Ps 107,1',
        mood: 'gratitude',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '6',
        text: 'Nie lękajcie się, bo Jam jest z wami.',
        reference: 'Iz 41,10',
        mood: 'loneliness',
        language: 'pl',
        translation: 'Biblia Tysiąclecia',
      ),
      Quote(
        id: '7',
        text: 'Be anxious for nothing, but in everything by prayer and supplication, with thanksgiving, let your requests be made known to God.',
        reference: 'Philippians 4:6',
        mood: 'anxiety',
        language: 'en',
        translation: 'NIV',
      ),
      Quote(
        id: '8',
        text: 'The Lord is near to those who have a broken heart.',
        reference: 'Psalm 34:18',
        mood: 'sadness',
        language: 'en',
        translation: 'NIV',
      ),
      Quote(
        id: '9',
        text: 'Rejoice in the Lord always. Again I will say, rejoice!',
        reference: 'Philippians 4:4',
        mood: 'happiness',
        language: 'en',
        translation: 'NIV',
      ),
      Quote(
        id: '10',
        text: 'Give thanks to the Lord, for He is good; His love endures forever.',
        reference: 'Psalm 107:1',
        mood: 'gratitude',
        language: 'en',
        translation: 'NIV',
      ),
      Quote(
        id: '11',
        text: 'In your anger do not sin. Do not let the sun go down while you are still angry.',
        reference: 'Ephesians 4:26',
        mood: 'anger',
        language: 'en',
        translation: 'NIV',
      ),
      Quote(
        id: '12',
        text: 'So do not fear, for I am with you.',
        reference: 'Isaiah 41:10',
        mood: 'loneliness',
        language: 'en',
        translation: 'NIV',
      ),
    ];
  }

  Future<void> saveUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateUserLastActive(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'lastActive': Timestamp.fromDate(DateTime.now())});
  }
}

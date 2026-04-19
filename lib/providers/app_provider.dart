import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';
import '../models/mood.dart';
import '../services/firebase_service.dart';

class AppProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final Random _random = Random();

  String _currentLanguage = 'pl';
  Quote? _currentQuote;
  bool _isLoading = false;
  List<Quote> _quoteHistory = [];

  String get currentLanguage => _currentLanguage;
  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  List<Quote> get quoteHistory => List.unmodifiable(_quoteHistory);

  AppProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('user_language') ?? 'pl';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language', language);
    notifyListeners();
  }

  String getLanguageDisplayName(String language) {
    switch (language) {
      case 'pl':
        return 'Polski';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      default:
        return language;
    }
  }

  List<Map<String, String>> get availableLanguages => [
    {'code': 'pl', 'name': 'Polski'},
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'de', 'name': 'Deutsch'},
  ];

  Future<void> fetchQuoteForMood(Mood mood) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final quote = await _firebaseService.getRandomQuote(
        mood.key,
        _currentLanguage,
      );

      if (quote != null) {
        _currentQuote = quote;
        _quoteHistory.add(quote);

        if (_quoteHistory.length > 50) {
          _quoteHistory.removeAt(0);
        }
      }
    } catch (e) {
      debugPrint('Error fetching quote: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentQuote() {
    _currentQuote = null;
    notifyListeners();
  }
}

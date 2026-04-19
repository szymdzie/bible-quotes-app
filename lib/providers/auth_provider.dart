import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _appUser;
  bool _isLoading = false;

  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _appUser != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final language = prefs.getString('user_language') ?? 'pl';
    if (name != null) {
      _appUser = AppUser(
        uid: 'local',
        name: name,
        language: language,
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> signInAnonymously(String name, String language) async {
    _isLoading = true;
    notifyListeners();

    try {
      _appUser = AppUser(
        uid: 'local',
        name: name,
        language: language,
        createdAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_language', language);
      await prefs.setBool('onboarding_complete', true);
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      _appUser = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

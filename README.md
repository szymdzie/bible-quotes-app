# Bible Quotes App

Aplikacja mobilna z cytatami biblijnymi dopasowanymi do nastroju użytkownika.

## Opis

Aplikacja pozwala użytkownikom wybrać aktualny nastrój (Złość, Samotność, Niepokój, Smutek, Szczęście, Wdzięczność) i otrzymać losowy, inspirujący cytat z Biblii dopasowany do tego stanu emocjonalnego.

## Funkcje

- **Rejestracja kartami** - Interaktywny proces onboarding z wyborem języka i personalizacją
- **6 kategorii nastrojów** - Złość, Samotność, Niepokój, Smutek, Szczęście, Wdzięczność
- **Wielojęzyczność** - Wsparcie dla polskiego, angielskiego, hiszpańskiego i niemieckiego
- **Animacje** - Płynne animacje przejść i efekty wizualne
- **Tryb ciemny/jasny** - Automatyczny przełącznik motywów
- **Udostępnianie** - Możliwość generowania grafiki z cytatem do udostępnienia
- **Firebase** - Backend do przechowywania cytatów i danych użytkowników

## Tech Stack

- **Framework**: Flutter 3.0+
- **Backend**: Firebase (Firestore + Auth)
- **State Management**: Provider
- **Animacje**: Lottie, wbudowane animacje Flutter
- **UI**: Material Design 3

## Struktura projektu

```
lib/
├── main.dart              # Punkt wejścia aplikacji
├── firebase_options.dart  # Konfiguracja Firebase
├── models/                # Modele danych
│   ├── mood.dart         # Enum nastrojów
│   ├── quote.dart        # Model cytatu
│   └── user.dart         # Model użytkownika
├── providers/            # Zarządzanie stanem
│   ├── app_provider.dart
│   ├── auth_provider.dart
│   └── theme_provider.dart
├── screens/              # Ekrany aplikacji
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── quote_screen.dart
│   └── settings_screen.dart
├── services/            # Serwisy
│   └── firebase_service.dart
└── widgets/             # Własne widgety

assets/
├── data/               # Dane cytatów (JSON)
├── images/            # Obrazy
└── animations/        # Animacje Lottie
```

## Instalacja

1. Zainstaluj Flutter: https://flutter.dev/docs/get-started/install
2. Sklonuj repozytorium
3. Zainstaluj zależności:
   ```bash
   flutter pub get
   ```
4. Skonfiguruj Firebase:
   - Utwórz projekt w Firebase Console
   - Dodaj aplikacje Android/iOS
   - Pobierz pliki konfiguracyjne (`google-services.json` dla Android, `GoogleService-Info.plist` dla iOS)
   - Zaktualizuj `lib/firebase_options.dart` z własnymi danymi

5. Uruchom aplikację:
   ```bash
   flutter run
   ```

## Konfiguracja Firebase

### Firestore - struktura kolekcji

```
quotes/
  ├── {quote_id}/
  │   ├── text: string
  │   ├── reference: string
  │   ├── mood: string (anger|loneliness|anxiety|sadness|happiness|gratitude)
  │   ├── language: string (pl|en|es|de)
  │   └── translation: string

users/
  ├── {user_id}/
  │   ├── name: string
  │   ├── email: string
  │   ├── language: string
  │   ├── createdAt: timestamp
  │   └── preferences: map
```

## Dodawanie nowych cytatów

Cytaty można dodać na dwa sposoby:

1. **Bezpośrednio do Firestore** - przez Firebase Console
2. **Do plików JSON** - dodaj do `assets/data/quotes_{lang}.json` i załaduj do Firestore przy pomocy skryptu

## Roadmap

- [x] Podstawowa struktura aplikacji
- [x] System rejestracji kartami
- [x] Ekran wyboru nastrojów
- [x] Losowanie cytatów
- [x] Animacje przejść
- [x] Tryb ciemny/jasny
- [x] Wielojęzyczność
- [ ] Integracja z Lottie
- [ ] Favorites - zapisywanie ulubionych cytatów
- [ ] Daily notifications - codzienne powiadomienia
- [ ] Widget na ekran główny

## Licencja

MIT License

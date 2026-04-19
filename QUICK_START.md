# Bible Quotes - Szybki Start

## ⚡ Uruchom na Własnym Urządzeniu

### Wymagania
- Flutter SDK 3.0+
- Android Studio / Xcode
- Firebase projekt (opcjonalnie)

### Krok po Kroku

```bash
# 1. Sklonuj projekt
git clone <repo-url>
cd bible_quotes_app

# 2. Zainstaluj zależności
flutter pub get

# 3. Sprawdź konfigurację
flutter doctor

# 4. Uruchom na emulatorze
flutter emulators --launch <emulator_id>
flutter run

# 5. Lub zbuduj APK
flutter build apk --debug
flutter install
```

---

## 🧪 Testowanie bez Urządzenia

### GitHub Actions (Automatyczne)

1. Wrzuć kod na GitHub
2. GitHub Actions automatycznie:
   - Analizuje kod
   - Uruchamia testy
   - Buduje APK (Android)
   - Buduje IPA (iOS)

### Lokalnie z Docker

```bash
# Jeśli masz Docker
docker run -it --rm \
  -v "$(pwd):/app" \
  -w /app \
  cirrusci/flutter:stable \
  sh -c "flutter pub get && flutter test"
```

---

## 🎯 Testy Manualne (Checklist)

### Rejestracja
- [ ] Wybierz język z listy
- [ ] Wpisz imię w polu tekstowym
- [ ] Przejdź tutorial (strzałki/swipe)
- [ ] Kliknij "Rozpocznij"

### Ekran Główny
- [ ] Widzisz 6 kolorowych przycisków
- [ ] Każdy przycisk ma ikonę i tekst
- [ ] Kliknij w każdy nastrój

### Cytaty
- [ ] Po kliknięciu pokazuje się animacja
- [ ] Pojawia się cytat z Biblii
- [ ] Widzisz referencję (np. "Ps 23,1")
- [ ] Przycisk "Inny cytat" losuje nowy
- [ ] Przycisk "Udostępnij" otwiera menu

### Ustawienia
- [ ] Zmień motyw na ciemny
- [ ] Zmień język na English
- [ ] Zobacz profil użytkownika
- [ ] Zresetuj aplikację (opcja)

---

## 📱 Podgląd UI (Zrzuty Ekranu)

### Splash Screen
```
┌───────────────────────────┐
│                           │
│         📖               │
│                           │
│    Bible Quotes          │
│   Cytaty dla Twojego    │
│       nastroju           │
│                           │
│      ◐  loading         │
│                           │
└───────────────────────────┘
```

### Onboarding - Karta 1
```
┌───────────────────────────┐
│  ──────────── progress    │
│                           │
│      🌐                  │
│                           │
│      Witaj               │
│  Wybierz język aplikacji │
│                           │
│  ○ Polski               │
│  ○ English               │
│  ○ Español              │
│  ○ Deutsch               │
│                           │
│   ┌───────────────────┐  │
│   │      Dalej        │  │
│   └───────────────────┘  │
└───────────────────────────┘
```

### Home Screen
```
┌───────────────────────────┐
│ Witaj        ⚙️          │
│ Znajdź inspirację        │
│                           │
│  Jak się czujesz?         │
│                           │
│ ┌─────────┐ ┌─────────┐  │
│ │  🔴     │ │   🩶    │  │
│ │  Złość  │ │Samotność│  │
│ └─────────┘ └─────────┘  │
│ ┌─────────┐ ┌─────────┐  │
│ │  🟠     │ │   🔵    │  │
│ │Niepokój │ │  Smutek │  │
│ └─────────┘ └─────────┘  │
│ ┌─────────┐ ┌─────────┐  │
│ │  🟡     │ │   🟢    │  │
│ │Szczęście│ │Wdzięczność│
│ └─────────┘ └─────────┘  │
└───────────────────────────┘
```

### Quote Screen
```
┌───────────────────────────┐
│ ←         😢 Smutek      │
│                           │
│  ┌─────────────────────┐  │
│  │                     │  │
│  │       💬            │  │
│  │                     │  │
│  │  "Pan bliski jest   │  │
│  │   strwojonym        │  │
│  │   sercom..."         │  │
│  │                     │  │
│  │     ───────         │  │
│  │     Ps 34,19        │  │
│  │  Biblia Tysiąclecia │  │
│  │                     │  │
│  └─────────────────────┘  │
│                           │
│ ┌─────────┐ ┌─────────┐  │
│ │ 🔄 Inny │ │ 📤 Udos │  │
│ │  cytat  │ │  tępnij │  │
│ └─────────┘ └─────────┘  │
└───────────────────────────┘
```

---

## 🔧 Rozwiązywanie Problemów

### Błąd: `flutter: command not found`
```bash
# Dodaj do ~/.zshrc lub ~/.bashrc
export PATH="$PATH:$HOME/development/flutter/bin"
source ~/.zshrc
```

### Błąd: `firebase_auth` nie działa
```bash
# Opcja 1: Pomiń Firebase (fallback quotes działają)
# Aplikacja używa lokalnych cytatów

# Opcja 2: Skonfiguruj Firebase
# 1. Utwórz projekt w console.firebase.google.com
# 2. Dodaj aplikację Android/iOS
# 3. Pobierz google-services.json / GoogleService-Info.plist
# 4. Wklej do android/app/ lub ios/Runner/
```

### Błąd: `minSdkVersion` too low
```bash
# W android/app/build.gradle zmień:
minSdkVersion 21
```

---

## 📊 Status Testów

| Test | Status |
|------|--------|
| Analiza statyczna | ⏳ Oczekuje na `flutter analyze` |
| Unit tests | ⏳ Oczekuje na `flutter test` |
| Build Android | ⏳ Oczekuje na `flutter build apk` |
| Build iOS | ⏳ Oczekuje na `flutter build ios` |
| Integration tests | ⏳ Do wykonania ręcznie |

---

**Rozwiązania:**
1. Uruchom na systemie z macOS 14+ / Linux / Windows
2. Użyj GitHub Actions (automatyczne testy)
3. Użyj Docker z Flutter

**Projekt jest gotowy do przeniesienia i uruchomienia na docelowym systemie! 🚀**

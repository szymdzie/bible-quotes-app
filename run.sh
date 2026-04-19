#!/bin/bash

# Skrypt uruchomieniowy aplikacji Bible Quotes

set -e

echo "=========================================="
echo "    Bible Quotes App - Uruchomienie"
echo "=========================================="
echo ""

# Sprawdź czy Flutter jest zainstalowany
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter nie jest zainstalowany!"
    echo ""
    echo "Zainstaluj Flutter:"
    echo "  1. Pobierz z: https://flutter.dev/docs/get-started/install"
    echo "  2. Dodaj do PATH: export PATH=\"\$PATH:/ścieżka/do/flutter/bin\""
    echo ""
    exit 1
fi

echo "✅ Flutter znaleziony: $(flutter --version | head -1)"
echo ""

# Sprawdź czy pliki konfiguracyjne Firebase istnieją
if [ ! -f "android/app/google-services.json" ]; then
    echo "⚠️  Brak pliku google-services.json dla Android"
    echo "   Dodaj go z Firebase Console -> Project Settings"
fi

if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "⚠️  Brak pliku GoogleService-Info.plist dla iOS"
    echo "   Dodaj go z Firebase Console -> Project Settings"
fi

echo ""
echo "📦 Instalowanie zależności..."
flutter pub get

echo ""
echo "🔨 Budowanie aplikacji..."
flutter build apk --debug

echo ""
echo "=========================================="
echo "  ✅ Aplikacja gotowa do uruchomienia!"
echo "=========================================="
echo ""
echo "Uruchom na emulatorze/urządzeniu:"
echo "  flutter run"
echo ""
echo "Lub zainstaluj APK:"
echo "  flutter install"
echo ""

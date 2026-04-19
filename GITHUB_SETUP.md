# GitHub Setup - Bible Quotes App

## 🚀 Szybka Konfiguracja GitHub Actions

Repozytorium git zostało zainicjalizowane lokalnie. Teraz musisz połączyć je z GitHub.

---

## Krok 1: Utwórz Repozytorium na GitHub

### Opcja A: Przez Stronę (Polecane dla początkujących)

1. Wejdź na [github.com/new](https://github.com/new)
2. **Repository name:** `bible-quotes-app`
3. **Description:** `Flutter app with Bible quotes matched to your mood`
4. **Visibility:** Public (lub Private)
5. **☐** Initialize this repository with a README (ODZNACZ - mamy już README)
6. Kliknij **Create repository**

### Opcja B: Przez GitHub CLI (dla zaawansowanych)

```bash
# Zainstaluj gh CLI: https://cli.github.com/
gh auth login
gh repo create bible-quotes-app --public --description "Flutter app with Bible quotes"
```

---

## Krok 2: Połącz Lokalne Repozytorium z GitHub

Po utworzeniu repozytorium, GitHub pokaże Ci instrukcje. Wybierz **"…or push an existing repository from the command line"**

Skopiuj i wklej te komendy:

```bash
cd /Users/imac27/CascadeProjects/bible_quotes_app

git remote add origin https://github.com/TWOJ_USERNAME/bible-quotes-app.git

git branch -M main

git push -u origin main
```

**Zastąp `TWOJ_USERNAME` swoją nazwą użytkownika GitHub**

---

## Krok 3: Włącz GitHub Actions

Po wypchnięciu kodu:

1. Wejdź w zakładkę **Actions** w swoim repozytorium
2. Kliknij **I understand my workflows, go ahead and enable them**
3. GitHub automatycznie uruchomi workflow:
   - ✅ Analiza kodu (`flutter analyze`)
   - ✅ Testy (`flutter test`)
   - ✅ Build Android APK
   - ✅ Build iOS (bez podpisu)

---

## Krok 4: Sprawdź Wyniki

### W Zakładce Actions Zobaczysz:

```
✅ analyze      - flutter analyze (2 min)
✅ test         - flutter test --coverage (3 min)
✅ build-android - flutter build apk (8 min)
✅ build-ios    - flutter build ios (12 min)
```

### W Zakładce Releases (po poprawnym buildzie):

GitHub Actions automatycznie zbuduje APK. Możesz pobrać:
- `app-release.apk` - gotowy do instalacji na Androidzie

---

## 📋 Skrypt Jednoliniowy (Opcjonalnie)

Możesz zapisać to jako skrypt `setup_github.sh`:

```bash
#!/bin/bash
set -e

echo "🔗 Konfiguracja GitHub dla Bible Quotes App"
echo ""

# Sprawdź czy gh CLI jest zainstalowane
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) nie jest zainstalowane"
    echo "Zainstaluj: brew install gh"
    exit 1
fi

# Zaloguj się
echo "📝 Logowanie do GitHub..."
gh auth status || gh auth login

# Utwórz repozytorium
echo "📦 Tworzenie repozytorium..."
gh repo create bible-quotes-app --public \
    --description "Flutter app with Bible quotes matched to your mood" \
    --source=. --remote=origin --push

echo ""
echo "✅ Gotowe!"
echo "Otwórz: https://github.com/$(gh api user -q .login)/bible-quotes-app/actions"
```

Uruchomienie:
```bash
chmod +x setup_github.sh
./setup_github.sh
```

---

## 🔧 Alternatywa: HTTPS z Tokenem

Jeśli nie chcesz używać GitHub CLI:

### Generuj Token:
1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Zaznacz: `repo`, `workflow`
4. Kopiuj token (wyświetli się tylko raz!)

### Użyj Tokena:
```bash
cd /Users/imac27/CascadeProjects/bible_quotes_app

# Zamiast hasła użyj tokena
git remote add origin https://TWOJ_USERNAME:TOKEN@github.com/TWOJ_USERNAME/bible-quotes-app.git

git push -u origin main
```

---

## ✅ Weryfikacja Po Wypchnięciu

### Sprawdź lokalnie:
```bash
git log --oneline --graph --all
# Powinieneś zobaczyć:
# * ffc554a (HEAD -> main, origin/main) Initial commit: Bible Quotes App...
```

### Sprawdź na GitHub:
1. Wejdź na `https://github.com/TWOJ_USERNAME/bible-quotes-app`
2. Powinieneś zobaczyć wszystkie pliki:
   - `lib/` - kod źródłowy
   - `.github/workflows/flutter.yml` - konfiguracja CI/CD
   - `README.md`, `pubspec.yaml`, itd.

---

## 🎬 Co Się Stanie Po Wypchnięciu

### Automatycznie (w ciągu ~30 minut):

| Zadanie | Czas | Rezultat |
|---------|------|----------|
| Analiza kodu | ~2 min | ✅ / ❌ |
| Testy jednostkowe | ~3 min | ✅ / ❌ |
| Build Android APK | ~8 min | Plik `.apk` do pobrania |
| Build iOS | ~12 min | Plik `.app` (bez podpisu) |

### Powiadomienie:
GitHub wyśle Ci email z wynikami buildu.

---

## 🆘 Rozwiązywanie Problemów

### Problem: `remote: Permission denied`
```bash
# Sprawdź czy jesteś zalogowany
git config user.name
git config user.email

# Zaloguj się do GitHub CLI
gh auth login
```

### Problem: `fatal: Authentication failed`
```bash
# Na macOS użyj Keychain
git config --global credential.helper osxkeychain

# Wyczyść cache i spróbuj ponownie
git credential-cache exit
git push
```

### Problem: `src refspec main does not match`
```bash
# Upewnij się że jesteś na branchu main
git checkout main
git branch -M main
```

---

## 📊 Status Repozytorium Lokalnego

```
Branch: main
Commit: ffc554a Initial commit: Bible Quotes App with Flutter
Pliki: 62 obiektów git
Gotowe do wypchnięcia: TAK ✅
```

**Następny krok:** Wypchnij kod na GitHub używając instrukcji powyżej.

---

## 🎯 Po Wypchnięciu - Co Dalej?

1. **Sprawdź Actions**: https://github.com/TWOJ_USERNAME/bible-quotes-app/actions
2. **Pobierz APK**: Wejdź w najnowszy workflow → build-android → Artifacts
3. **Zainstaluj na telefonie**: `adb install app-release.apk`

---

**Gotowe do wypchnięcia! 🚀**

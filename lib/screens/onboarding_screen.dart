import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  String _selectedLanguage = 'pl';
  String _userName = '';

  final List<OnboardingCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initCards();
  }

  void _initCards() {
    _cards.addAll([
      OnboardingCard(
        title: 'Witaj',
        titleEn: 'Welcome',
        description: 'Wybierz język aplikacji',
        descriptionEn: 'Choose your language',
        icon: Icons.language,
        color: const Color(0xFF6B4E71),
        child: _buildLanguageSelector(),
      ),
      OnboardingCard(
        title: 'Jak masz na imię?',
        titleEn: 'What\'s your name?',
        description: 'Personalizuj swoje doświadczenie',
        descriptionEn: 'Personalize your experience',
        icon: Icons.person,
        color: const Color(0xFF7BA3B8),
        child: _buildNameInput(),
      ),
      OnboardingCard(
        title: 'Jak to działa?',
        titleEn: 'How it works',
        description: 'Wybierz nastrój, a my znajdziemy cytat',
        descriptionEn: 'Select a mood, we\'ll find a quote',
        icon: Icons.lightbulb,
        color: const Color(0xFF81C784),
        child: _buildTutorial(),
      ),
      OnboardingCard(
        title: 'Gotowy?',
        titleEn: 'Ready?',
        description: 'Rozpocznij swoją duchową podróż',
        descriptionEn: 'Start your spiritual journey',
        icon: Icons.check_circle,
        color: const Color(0xFFFFB74D),
        child: _buildFinalCard(),
      ),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _cards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_userName.isEmpty) {
      _userName = 'Użytkownik';
    }

    try {
      await context.read<AuthProvider>().signInAnonymously(
            _userName,
            _selectedLanguage,
          );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildLanguageSelector() {
    final appProvider = context.read<AppProvider>();
    final languages = appProvider.availableLanguages;

    return Column(
      children: languages.map((lang) {
        final isSelected = lang['code'] == _selectedLanguage;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedLanguage = lang['code']!;
              });
              appProvider.setLanguage(lang['code']!);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6B4E71).withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6B4E71)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? const Color(0xFF6B4E71) : Colors.grey,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    lang['name']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? const Color(0xFF6B4E71) : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNameInput() {
    return TextField(
      onChanged: (value) => setState(() => _userName = value),
      decoration: InputDecoration(
        hintText: _selectedLanguage == 'pl' ? 'Wpisz swoje imię' : 'Enter your name',
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.person_outline),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildTutorial() {
    final moods = [
      {'icon': Icons.sentiment_very_dissatisfied, 'label': 'Złość', 'color': Colors.red},
      {'icon': Icons.person_outline, 'label': 'Samotność', 'color': Colors.grey},
      {'icon': Icons.warning_amber, 'label': 'Niepokój', 'color': Colors.orange},
      {'icon': Icons.sentiment_dissatisfied, 'label': 'Smutek', 'color': Colors.blue},
      {'icon': Icons.sentiment_satisfied, 'label': 'Szczęście', 'color': Colors.yellow},
      {'icon': Icons.favorite, 'label': 'Wdzięczność', 'color': Colors.green},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: moods.map((mood) {
        return Chip(
          avatar: Icon(mood['icon'] as IconData, color: mood['color'] as Color),
          label: Text(mood['label'] as String),
          backgroundColor: (mood['color'] as Color).withOpacity(0.1),
        );
      }).toList(),
    );
  }

  Widget _buildFinalCard() {
    return Column(
      children: [
        Icon(
          Icons.menu_book,
          size: 64,
          color: const Color(0xFFFFB74D),
        ),
        const SizedBox(height: 16),
        Text(
          _selectedLanguage == 'pl'
              ? 'Gotowy, $_userName!'
              : 'Ready, $_userName!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _selectedLanguage == 'pl'
              ? 'Kliknij poniższy przycisk, aby rozpocząć'
              : 'Click the button below to start',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _cards.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: _previousPage,
                      icon: const Icon(Icons.arrow_back),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / _cards.length,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(_cards[_currentPage].color),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return _buildCard(card);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLastPage ? _completeOnboarding : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cards[_currentPage].color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isLastPage
                        ? (_selectedLanguage == 'pl' ? 'Rozpocznij' : 'Start')
                        : (_selectedLanguage == 'pl' ? 'Dalej' : 'Next'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(OnboardingCard card) {
    final isPolish = _selectedLanguage == 'pl';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: card.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  card.icon,
                  size: 40,
                  color: card.color,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isPolish ? card.title : card.titleEn,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: card.color,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                isPolish ? card.description : card.descriptionEn,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              card.child,
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingCard {
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final IconData icon;
  final Color color;
  final Widget child;

  OnboardingCard({
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.icon,
    required this.color,
    required this.child,
  });
}

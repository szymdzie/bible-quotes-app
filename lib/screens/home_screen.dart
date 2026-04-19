import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mood.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import 'quote_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  final List<Animation<double>> _cardAnimations = [];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));

    for (int i = 0; i < Mood.all.length; i++) {
      final start = (i * 0.12).clamp(0.0, 0.7);
      final end = (start + 0.4).clamp(0.0, 1.0);
      _cardAnimations.add(
        CurvedAnimation(
          parent: _cardsController,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    }

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isPolish = appProvider.currentLanguage == 'pl';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1228), const Color(0xFF0F0F1A)]
                : [const Color(0xFFF5F0FF), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context, isPolish, isDark)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                sliver: SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Text(
                      isPolish ? 'Jak się czujesz?' : 'How are you feeling?',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final mood = Mood.all[index];
                      return ScaleTransition(
                        scale: _cardAnimations[index],
                        child: FadeTransition(
                          opacity: _cardAnimations[index],
                          child: _MoodCard(mood: mood, isPolish: isPolish),
                        ),
                      );
                    },
                    childCount: Mood.all.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isPolish, bool isDark) {
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B4E71), Color(0xFF9B7BA0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4E71).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPolish ? 'Witaj 👋' : 'Hello 👋',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                    ),
                    Text(
                      isPolish ? 'Znajdź inspirację' : 'Find inspiration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              _SettingsButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatefulWidget {
  @override
  State<_SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<_SettingsButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _rotation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _ctrl.forward().then((_) => _ctrl.reverse());
        Navigator.push(context, _slideRoute(const SettingsScreen()));
      },
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (_, __) => RotationTransition(
          turns: _rotation,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
            ),
            child: const Icon(Icons.settings_rounded, size: 22),
          ),
        ),
      ),
    );
  }
}

class _MoodCard extends StatefulWidget {
  final Mood mood;
  final bool isPolish;

  const _MoodCard({required this.mood, required this.isPolish});

  @override
  State<_MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<_MoodCard> with SingleTickerProviderStateMixin {
  late AnimationController _tapCtrl;
  late Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _tapCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget.mood;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _tapCtrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _tapCtrl.reverse();
        Navigator.push(context, _fadeScaleRoute(QuoteScreen(mood: mood)));
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _tapCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        mood.color.withOpacity(_pressed ? 0.35 : 0.2),
                        mood.color.withOpacity(_pressed ? 0.15 : 0.08),
                      ]
                    : [
                        mood.color.withOpacity(_pressed ? 0.25 : 0.12),
                        mood.color.withOpacity(_pressed ? 0.12 : 0.05),
                      ],
              ),
              border: Border.all(
                color: mood.color.withOpacity(_pressed ? 0.7 : 0.3),
                width: _pressed ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: mood.color.withOpacity(_pressed ? 0.4 : 0.15),
                  blurRadius: _pressed ? 20 : 8,
                  offset: const Offset(0, 4),
                  spreadRadius: _pressed ? 2 : 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mood.color.withOpacity(0.07),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            mood.color.withOpacity(0.35),
                            mood.color.withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: mood.color.withOpacity(0.3),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(mood.icon, size: 32, color: mood.color),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.isPolish ? mood.displayName : mood.displayNameEn,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: mood.color,
                            letterSpacing: 0.3,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 30,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: mood.color.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PageRoute _slideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

PageRoute _fadeScaleRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

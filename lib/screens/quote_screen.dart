import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/mood.dart';
import '../models/quote.dart';
import '../providers/app_provider.dart';

class QuoteScreen extends StatefulWidget {
  final Mood mood;

  const QuoteScreen({super.key, required this.mood});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _orbController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  final GlobalKey _quoteKey = GlobalKey();
  bool _showQuote = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _fetchQuote();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  Future<void> _fetchQuote() async {
    final appProvider = context.read<AppProvider>();
    await appProvider.fetchQuoteForMood(widget.mood);
    if (!mounted) return;
    setState(() => _showQuote = true);
    _controller.forward(from: 0);
  }

  Future<void> _shareQuote() async {
    try {
      final boundary = _quoteKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final pngBytes = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/quote_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(imagePath)], text: 'Bible Quote for you');
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  void _getAnotherQuote() {
    setState(() => _showQuote = false);
    _controller.reset();
    _fetchQuote();
  }

  @override
  void dispose() {
    _controller.dispose();
    _orbController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final quote = appProvider.currentQuote;
    final isPolish = appProvider.currentLanguage == 'pl';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodColor = widget.mood.color;

    return Scaffold(
      body: Stack(
        children: [
          // Animated orb background
          AnimatedBuilder(
            animation: _orbController,
            builder: (_, __) {
              final t = _orbController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(const Color(0xFF2D1B4E), moodColor, 0.15)!,
                      const Color(0xFF1A0F2E),
                      Color.lerp(const Color(0xFF120B22), moodColor, 0.05)!,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: _OrbPainter(
                    color: moodColor,
                    progress: t,
                    isDark: isDark,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, isPolish),
                Expanded(
                  child: appProvider.isLoading
                      ? _buildLoadingAnimation()
                      : quote == null
                          ? _buildErrorWidget(isPolish)
                          : _buildQuoteContent(quote, isPolish),
                ),
                if (_showQuote && quote != null) _buildActionButtons(isPolish),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isPolish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white.withOpacity(0.8), size: 18),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.mood.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.mood.color.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.mood.icon, color: Colors.white.withOpacity(0.9), size: 18),
                const SizedBox(width: 6),
                Text(
                  isPolish ? widget.mood.displayName : widget.mood.displayNameEn,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (_, __) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: null,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.mood.color.withOpacity(0.3),
                      ),
                      strokeWidth: 6,
                    ),
                  ),
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: CircularProgressIndicator(
                      value: _shimmerController.value,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.mood.color),
                      strokeWidth: 3,
                      backgroundColor: widget.mood.color.withOpacity(0.1),
                    ),
                  ),
                  Icon(widget.mood.icon, color: widget.mood.color, size: 28),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                isPolish ? 'Szukam inspiracji...' : 'Finding inspiration...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: widget.mood.color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool get isPolish =>
      context.read<AppProvider>().currentLanguage == 'pl';

  Widget _buildQuoteContent(Quote quote, bool isPolish) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: RepaintBoundary(
                key: _quoteKey,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: const Color(0xFF1E1235).withOpacity(0.85),
                    border: Border.all(
                      color: widget.mood.color.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.mood.color.withOpacity(0.25),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: widget.mood.color.withOpacity(0.08),
                        blurRadius: 60,
                        offset: const Offset(0, 0),
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              widget.mood.color.withOpacity(0.2),
                              widget.mood.color.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          size: 36,
                          color: widget.mood.color,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        quote.text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              height: 1.7,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 24, height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: widget.mood.color.withOpacity(0.4),
                              )),
                          const SizedBox(width: 8),
                          Icon(widget.mood.icon, size: 16, color: widget.mood.color),
                          const SizedBox(width: 8),
                          Container(width: 24, height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: widget.mood.color.withOpacity(0.4),
                              )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        quote.reference,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: widget.mood.color,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.mood.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          quote.translation,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: widget.mood.color.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(bool isPolish) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            isPolish ? 'Nie udało się pobrać cytatu' : 'Failed to load quote',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchQuote,
            child: Text(isPolish ? 'Spróbuj ponownie' : 'Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isPolish) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              onTap: _getAnotherQuote,
              color: widget.mood.color,
              icon: Icons.auto_awesome_rounded,
              label: isPolish ? 'Inny cytat' : 'Another',
              filled: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              onTap: _shareQuote,
              color: widget.mood.color,
              icon: Icons.ios_share_rounded,
              label: isPolish ? 'Udostępnij' : 'Share',
              filled: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final String label;
  final bool filled;

  const _ActionButton({
    required this.onTap,
    required this.color,
    required this.icon,
    required this.label,
    required this.filled,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
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
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: widget.filled
                  ? LinearGradient(
                      colors: [widget.color, widget.color.withOpacity(0.7)],
                    )
                  : null,
              color: widget.filled ? null : Colors.transparent,
              border: widget.filled
                  ? null
                  : Border.all(color: widget.color, width: 1.5),
              boxShadow: widget.filled
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: 18,
                    color: widget.filled ? Colors.white : widget.color),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.filled ? Colors.white : widget.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final Color color;
  final double progress;
  final bool isDark;

  _OrbPainter({required this.color, required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * pi;

    final orbs = [
      Offset(size.width * 0.2 + sin(t * 0.7) * size.width * 0.08,
             size.height * 0.15 + cos(t * 0.5) * size.height * 0.04),
      Offset(size.width * 0.8 + sin(t * 0.4 + 1.5) * size.width * 0.06,
             size.height * 0.35 + cos(t * 0.6 + 1) * size.height * 0.05),
      Offset(size.width * 0.5 + sin(t * 0.3 + 3) * size.width * 0.07,
             size.height * 0.7 + cos(t * 0.4 + 2) * size.height * 0.04),
    ];

    final radii = [size.width * 0.35, size.width * 0.28, size.width * 0.25];
    final opacities = [0.15, 0.12, 0.09];

    for (int i = 0; i < orbs.length; i++) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withOpacity(opacities[i]),
            color.withOpacity(0),
          ],
        ).createShader(Rect.fromCircle(center: orbs[i], radius: radii[i]));
      canvas.drawCircle(orbs[i], radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) =>
      old.progress != progress || old.color != color;
}

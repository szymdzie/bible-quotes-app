import 'dart:io';
import 'dart:typed_data';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
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
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  Future<void> _fetchQuote() async {
    final appProvider = context.read<AppProvider>();
    await appProvider.fetchQuoteForMood(widget.mood);

    if (!mounted) return;

    setState(() {
      _showQuote = true;
    });

    _controller.forward();
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

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: 'Bible Quote for you',
      );
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  void _getAnotherQuote() {
    setState(() {
      _showQuote = false;
    });
    _controller.reset();
    _fetchQuote();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final quote = appProvider.currentQuote;
    final isPolish = appProvider.currentLanguage == 'pl';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    widget.mood.color.withOpacity(0.2),
                    const Color(0xFF1A1A2E),
                  ]
                : [
                    widget.mood.color.withOpacity(0.1),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
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
              if (!_showQuote && !appProvider.isLoading)
                _buildErrorWidget(isPolish),
              if (_showQuote && quote != null) _buildActionButtons(isPolish),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isPolish) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: widget.mood.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.mood.icon, color: widget.mood.color, size: 20),
                const SizedBox(width: 8),
                Text(
                  isPolish ? widget.mood.displayName : widget.mood.displayNameEn,
                  style: TextStyle(
                    color: widget.mood.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(widget.mood.color),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Szukam inspiracji...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteContent(Quote quote, bool isPolish) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: RepaintBoundary(
                  key: _quoteKey,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: widget.mood.color.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 48,
                          color: widget.mood.color.withOpacity(0.5),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          quote.text,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 22,
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 60,
                          height: 2,
                          color: widget.mood.color.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          quote.reference,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: widget.mood.color,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          quote.translation,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(bool isPolish) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            isPolish ? 'Nie udało się pobrać cytatu' : 'Failed to load quote',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _getAnotherQuote,
                  icon: const Icon(Icons.refresh),
                  label: Text(isPolish ? 'Inny cytat' : 'Another quote'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.mood.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shareQuote,
                  icon: const Icon(Icons.share),
                  label: Text(isPolish ? 'Udostępnij' : 'Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.mood.color,
                    side: BorderSide(color: widget.mood.color),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

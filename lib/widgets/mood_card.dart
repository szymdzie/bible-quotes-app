import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodCard extends StatefulWidget {
  final Mood mood;
  final bool isPolish;
  final VoidCallback onTap;

  const MoodCard({
    super.key,
    required this.mood,
    required this.isPolish,
    required this.onTap,
  });

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final mood = widget.mood;
    final label = widget.isPolish ? mood.displayName : mood.displayNameEn;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: mood.color.withOpacity(_isHovered ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: mood.color.withOpacity(_isHovered ? 0.5 : 0.3),
                  width: _isHovered ? 3 : 2,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: mood.color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _isHovered ? 65 : 60,
                    height: _isHovered ? 65 : 60,
                    decoration: BoxDecoration(
                      color: mood.color.withOpacity(_isHovered ? 0.3 : 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      mood.icon,
                      size: _isHovered ? 36 : 32,
                      color: mood.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: _isHovered ? FontWeight.bold : FontWeight.w600,
                          color: mood.color.withOpacity(_isHovered ? 1.0 : 0.8),
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

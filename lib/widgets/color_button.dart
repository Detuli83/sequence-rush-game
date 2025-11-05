import 'package:flutter/material.dart';

class ColorButton extends StatefulWidget {
  final Color color;
  final VoidCallback onPressed;
  final double size;
  final bool isHighlighted;

  const ColorButton({
    super.key,
    required this.color,
    required this.onPressed,
    this.size = 100,
    this.isHighlighted = false,
  });

  @override
  State<ColorButton> createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.isHighlighted
                    ? widget.color.withOpacity(0.8)
                    : widget.color.withOpacity(0.3),
                blurRadius: widget.isHighlighted ? 20 : 8,
                spreadRadius: widget.isHighlighted ? 4 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
